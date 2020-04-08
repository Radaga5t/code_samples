# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса user_configurations
    class UserConfigurationsController < ApiController
      before_action :authenticate_user!

      def update
        current_user.update(
          jsonapi_deserialize(params,
                              only: %i[interface_configuration subscribe_to_system_messages
                                       subscribe_to_site_news hidden_until
                                       payment_city payment_street payment_postal_code payment_house_number])
        )
        current_user.recover if jsonapi_deserialize(params, only: :recover).dig('recover')
        render json: current_user.auth_response
      end
    end
  end
end
