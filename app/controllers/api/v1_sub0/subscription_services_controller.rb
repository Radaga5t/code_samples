# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса subscription_services
    class SubscriptionServicesController < ApiController
      def index
        json_response(
          Services::Subscriptions::SubscriptionService
            .includes(:translations)
            .order(sort: :asc)
            .where(active: true)
        )
      end
    end
  end
end
