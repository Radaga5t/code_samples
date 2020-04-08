# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса categories
    class CategoriesController < ApiController
      def index
        authorize Category
        json_response policy_scope(Category).includes(:translations, :icon).all
      end

      def show
        cat = Category.find(params[:id])
        authorize cat
        json_response cat
      end

      private

      def jsonapi_serializer_params
        super.merge!(simple: true) if action_name == 'index'
        super
      end
    end
  end
end
