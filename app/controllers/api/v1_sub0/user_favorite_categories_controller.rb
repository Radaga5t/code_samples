# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса users/:userId/user_favorite_categories
    class UserFavoriteCategoriesController < ApiController
      before_action :authenticate_user!,
                    unless: -> { params[:user_id].present? }

      def index
        authorize UserFavoriteCategory

        elements = \
          if params[:user_id].present?
            UserFavoriteCategory.where(user_id: params[:user_id])
          else
            UserFavoriteCategory.where(user_id: current_user.id)
          end

        json_response(
          elements,
          options: {
            is_collection: true
          }
        )
      end

      def update
        element = policy_scope(UserFavoriteCategory).find(params[:id])
        authorize element
        element.update(jsonapi_deserialize(params, except: [:id]))
        json_response(element)
      end
    end
  end
end
