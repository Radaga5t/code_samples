# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса users/:userId/user_verifications
    class UserVerificationsController < ApiController
      before_action :authenticate_user!,
                    if: :check_authorization
      def show
        json_response(
          if params[:user_id]
            User.fast_find(params[:user_id]).user_verification
          else
            current_user.user_verification
          end
        )
      end

      def update
        p = \
          if request.content_type == JSONAPI_MEDIA_TYPE
            jsonapi_params(only: %i[identity_document_file executor_photo_file])
          else
            params.permit(:identity_document_file, :executor_photo_file)
          end
        user_verification = current_user.user_verification

        action_meta = jsonapi_action_meta

        if action_meta&.dig(:action_name)
          confirm_phone_request(user_verification) if action_meta.dig(:action_name) == 'confirm_phone_request'
          if action_meta.dig(:action_name) == 'confirm_phone'
            confirm_phone(
              user_verification,
              action_meta.dig(:attributes)&.first
            )
          end
        elsif p.include?(:identity_document_file)
          user_verification
            .update(
              identity_document_attributes: {
                file: p[:identity_document_file]
              }
            )
        elsif p.include?(:executor_photo_file)
          user_verification
            .update(
              executor_photo_attributes: {
                file: p[:executor_photo_file]
              }
            )
        end

        json_response(user_verification)
      end

      private

      def confirm_phone_request(user_verification)
        user_verification.confirm_phone_request
      end

      def confirm_phone(user_verification, code)
        user_verification.confirm_phone_with_code(code)
      end

      def check_authorization
        params[:user_id].blank? || %w[update].include?(action_name)
      end
    end
  end
end
