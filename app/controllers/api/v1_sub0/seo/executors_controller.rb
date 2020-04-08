# frozen_string_literal: true

module Api
  module V1Sub0
    module Seo
      # SEO entities controller
      class ExecutorsController < SeoController
        before_action :set_serializer

        def index
          json_response(collection)
        end

        def show
          json_response(User.find(params.dig(:slug)))
        end

        private

        # User (executor): id, name, lastname, sex, about, birthday, review_statistic, rating, price_per_hour,
        #                  online, avatar, city, last_review_as_executor (UserReview), last_review_user_data (User - last reviewer)
        # UserReviews: id, text, courtesy, punctuality, adequacy, task.title, task.id
        # UserReviews.author (User): id, name, avatar
        def collection
          seo_cat_id = ::Seo::Category.where(slug: params.dig(:filter, :category)).limit(1).pluck(:category_id)
          location = params.dig(:filter, :city)
          return [] if seo_cat_id.blank?
          scope = User.includes(:translations, :user_roles, :user_rating,
                                :user_verification, :portfolios, :user_account, :reviews,
                                :task_responses, :user_favorite_categories, :photo)
                    .executors
                    .where(user_favorite_categories: { category_id: seo_cat_id.first })
          if location.present?
            scope = scope.where("users.id in (SELECT geocoded.id FROM (
                                      #{User.near(location,
                                                  params.dig(:filter, :distance) || 5,
                                                  units: :km,
                                                  select: 'id').to_sql}
                                    ) geocoded)")
          end

          return [] if seo_cat_id.blank?

          scope = User.includes(:translations, :user_roles, :user_rating,
                                :user_verification, :portfolios, :user_account, :reviews,
                                :task_responses, :user_favorite_categories, :photo)
                    .executors
                    .where(user_favorite_categories: { category_id: seo_cat_id.first })
                    # .where("users.id in (
                    #   SELECT users.id FROM users
                    #   LEFT JOIN user_ratings on user_ratings.user_id = users.id
                    #   LEFT JOIN user_reviews on user_reviews.user_rating_id = user_ratings.id
                    #   GROUP BY users.id
                    #   HAVING count(user_reviews.id) > 0
                    # )")

          if location.present?
            scope = scope.where("users.id in (SELECT geocoded.id FROM (
                                      #{User.near(location,
                                                  params.dig(:filter, :distance) || 5,
                                                  units: :km,
                                                  select: 'id').to_sql}
                                    ) geocoded)")
          end

          users = jsonapi_paginate(scope).to_a

          return [] if users.blank?

          reviews_sql = <<~SQL
            select a.id from (
              select r.id, r.user_rating_id, row_number() over (partition by user_rating_id order by r.created_at desc) as rownum 
              from user_reviews r
              join user_ratings ur on ur.id = r.user_rating_id
              where ur.user_id IN (#{users.map(&:id).join(',')})
            ) a
            where rownum = 1
          SQL

          reviews_ids = ActiveRecord::Base.connection.exec_query(reviews_sql).to_hash.map{ |rev| rev.dig('id') }
          reviews = UserReview.includes(:translations).where(id: reviews_ids).to_a
          reviews_author_ids = reviews.map(&:author_id)
          reviews_authors = User.where(id: reviews_author_ids).to_a
          users.map do |user|
            user.last_review_as_executor = reviews.find do |review|
              review.user_rating_id == user.user_rating_id
            end

            if user.last_review_as_executor.present?
              user.last_review_user_data = reviews_authors.find do |reviews_author|
                reviews_author.id == user.last_review_as_executor.author_id
              end
            end
          end

          users
        end

        def geocoded_scope(scope)
          location = params.dig(:filter, :city)
          distance = params.dig(:filter, :distance) || 5
          return scope.near(location, distance, units: :km) if location.present?

          scope
        end

        def set_serializer
          @jsonapi_serializer = 'Seo::ExecutorSerializer'
        end
      end
    end
  end
end
