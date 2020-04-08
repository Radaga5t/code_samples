# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса users/:userId/user_view_statistics
    class UserViewStatisticsController < ApiController
      before_action :authenticate_user!,
                    unless: -> { params[:user_id].present? }

      def show
        if params[:user_id].present?
          json_response(UserViewStatistic.find_by!(user_id: params[:user_id]))
        else
          json_response(UserViewStatistic.find_by!(user_id: current_user.id))
        end
      end
    end
  end
end
