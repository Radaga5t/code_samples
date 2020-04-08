# frozen_string_literal: true

module Api
  module V1Sub0
    module Faq
      # FAQ pages' controller
      class CategoriesController < V1Sub0::ApiController
        def index
          scope = ::Faq::Category.includes(:translations, :pages, :icon)
          return json_response(scope) if params.dig(:filter).blank?

          if params.dig(:filter, :id_eq).present?
            scope = scope.where(id: params.dig(:filter, :id_eq))
          end

          if params.dig(:filter, :parent_id_eq).present?
            if params.dig(:filter, :id_eq).blank?
              return json_response(scope.where(parent_id: params.dig(:filter, :parent_id_eq)))
            else
              scope = scope.or(
                ::Faq::Category.includes(:translations, :pages, :icon).where(parent_id: params.dig(:filter, :parent_id_eq))
              )
            end
          end

          json_response(scope)
        end
      end
    end
  end
end
