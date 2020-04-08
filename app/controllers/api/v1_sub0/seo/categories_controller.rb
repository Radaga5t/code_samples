# frozen_string_literal: true

module Api
  module V1Sub0
    module Seo
      # SEO categories controller
      class CategoriesController < SeoController
        before_action :set_serializer

        def index
          json_response(collection)
        end

        def show
          json_response(::Seo::Category.find_by(slug: params.dig(:id)))
        end

        private

        def collection
          scope = ::Seo::Category.includes(:translations, :cover_image, :icon).all.to_a

          executors_count = scope.map do |sc|
            User.includes(:user_favorite_categories)
                .where(user_favorite_categories: { category_id: sc.category_id })
                .count
          end

          scope.each_with_index do |sc, i|
            sc.users_count = executors_count[i]
          end

          scope
        end

        def set_serializer
          @jsonapi_serializer = 'Seo::CategorySerializer'
        end
      end
    end
  end
end
