# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса promocodes
    class PromocodesController < ApiController
      def index
        res = if jsonapi_filter_params([:label]).empty? || current_user.blank?
                []
              else
                jsonapi_filter(
                  Promocode
                    .includes(:translations)
                    .active_for_user_account(
                      current_user.user_account
                    ),
                  [:label]
                ).result
              end
        json_response(res)
      end
    end
  end
end
