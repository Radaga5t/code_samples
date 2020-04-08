# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса category_suggestions
    class CategorySuggestionsController < ApiController
      def index
        json_response(
          jsonapi_paginate(collection)
        )
      end

      private

      def collection
        return CategorySuggestion.includes(:translations) if params.dig(:filter, :query).blank?
        return CategorySuggestion.includes(:translations).top \
          if params.dig(:filter, :type).present? && params.dig(:filter, :type) == 'top'

        CategorySuggestion.includes(:translations).search(params.dig(:filter, :query))
      end
    end
  end
end
