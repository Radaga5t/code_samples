# frozen_string_literal: true

module Api
  module V1Sub0
    module Faq
      # FAQ pages controller
      class PagesController < V1Sub0::ApiController
        def index
          scope = ::Faq::Page.includes(:translations, :category)
          scope = tags_scope(scope)
          scope = search_scope(scope)

          json_response(
            jsonapi_filter(
              scope,
              %i[category_id popular category_slug]
            ).result
          )
        end

        def show
          page = ::Faq::Page
                   .where(id: params.dig(:id))
                   .or(
                     ::Faq::Page
                       .where(slug: params.dig(:id))
                   )
          json_response page.first!
        end

        private

        def jsonapi_serializer_params
          super.merge!(simple: true) if action_name == 'index'
          super
        end

        def tags_scope(scope)
          return scope if search_query.dig(:filter, :tag).blank?

          scope.where('? = ANY(tags)', search_query.dig(:filter, :tag))
        end

        def search_scope(scope)
          return scope if search_query.dig(:filter, :search_query).blank?

          scope.search(search_query.dig(:filter, :search_query))
        end

        def search_query
          params.permit(filter: [:search_query, :tag, :popular_true])
        end
      end
    end
  end
end
