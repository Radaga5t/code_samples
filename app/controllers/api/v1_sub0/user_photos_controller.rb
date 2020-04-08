# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса users/:userId/user_photo
    class UserPhotosController < ApiController
      before_action :authenticate_user!,
                    only: [:update]

      def show
        photo = if params[:user_id]
                  User.fast_find(params[:user_id]).photo
                else
                  current_user.photo.presence || current_user.create_photo
                end

        json_response(photo)
      end

      def update
        photo = current_user.photo
        p = if request.content_type == JSONAPI_MEDIA_TYPE
              jsonapi_deserialize(params, except: [:id])
            else
              params.permit(:crop_x, :crop_y, :crop_w, :crop_h, :file)
            end
        photo.update(p)
        json_response(photo)
      end
    end
  end
end
