# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса users
    class UsersController < ApiController
      before_action :authenticate_user!, only: [:show], unless: -> { params[:id].present? }
      after_action :verify_authorized, except: [:track_new_user_registration]

      def index
        authorize User
        json_response(policy_scope(User).includes(:translations, :photo).all)
      end

      def show
        if params[:id]
          record = User.find(params[:id])
          authorize record
          track_user_view(record.id)
          json_response(record)
        else
          authorize current_user if current_user
          json_response(current_user)
        end
      end

      def track_new_user_registration
        TrackWorkers::TrackNewUsersFromFrontendWorker.perform_async(
          params[:user_id],
          request.user_agent,
          request.ip,
          I18n.locale,
          Time.current,
          params[:type]
        )

        json_response result: :ok
      end

      def update
        authorize current_user if current_user

        action_meta = jsonapi_action_meta

        attr_list = \
          if current_user.executor? && current_user.user_verification.verified?
            %i[sex phone about price_per_hour languages categories city_name city
               payment_city payment_street payment_postal_code payment_house_number]
          else
            %i[name middlename lastname sex phone about birthday price_per_hour
               languages categories city_name city
               payment_city payment_street payment_postal_code payment_house_number]
          end

        current_user.update(
          jsonapi_deserialize(params,
                              only: attr_list)
        )

        current_user.become_executor if action_meta&.dig(:action_name) == 'become_executor_now'

        json_response(current_user)
      end

      private

      def track_user_view(user_id)
        TrackWorkers::TrackUserViewWorker.perform_async(
          user_id,
          session[:user_unique_session_id],
          request.ip,
          Time.current,
          current_user.present? ? current_user.id : nil
        )
      end
    end
  end
end
