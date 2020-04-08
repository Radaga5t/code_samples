# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса services
    class SingleOfferServicesController < ApiController
      def index
        json_response(
          Services::SingleOffers::SingleOfferService.active
        )
      end
    end
  end
end
