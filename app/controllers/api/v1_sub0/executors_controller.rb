# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса executors
    class ExecutorsController < ApiController
      def index
        jsonapi_filter(collection,
                       %i[
                          user_favorite_categories_category_id
                          user_verification_id_confirmed online
                          price_per_hour_cents
                       ]) do |filtered|
          json_response(
            jsonapi_paginate(filtered.result)
          )
        end
      end

      private

      def collection
        filtered_by_categories = jsonapi_filter_params(%i[user_favorite_categories_category_id])

        if filtered_by_categories.present?
          pos = params.dig(:filter, :city)
          scope = User
                    .includes(:translations, :user_roles, :photo, :user_verification, user_rating: :user_in_category_ratings)
                    .executors
                    .where('users.hidden_until is null OR users.hidden_until < ?', Time.current)
                    .where('deleted_at is null')
                    .where(
                      user_roles: { slug: 'executor' },
                      user_in_category_ratings: { category_id: filtered_by_categories['user_favorite_categories_category_id_in'] }
                    )

          if pos.present?
            scope = scope
              .where("users.id in (SELECT geocoded.id FROM (#{
                User.near(pos, params.dig(:filter, :distance) || 5, units: :km, select: 'id').to_sql
              }) geocoded)")
          end

          scope.reorder('user_in_category_ratings.rating DESC')
        else
          geocoded_scope(User)
            .includes(:translations, :user_roles, :photo, :user_verification)
            .executors
            .where('users.hidden_until is null OR users.hidden_until < ?', Time.current)
            .where('deleted_at is null')
            .reorder('users.profile_rating DESC, users.created_at DESC')
        end
      end

      def jsonapi_serializer_params
        super.merge!(simple: true)
        super
      end

      def geocoded_scope(scope)
        pos = params.dig(:filter, :city)
        distance = params.dig(:filter, :distance) || 5
        return scope.near(pos, distance, units: :km) if pos.present?

        scope
      end
    end
  end
end
