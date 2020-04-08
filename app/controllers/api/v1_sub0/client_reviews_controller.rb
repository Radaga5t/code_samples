# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для статичных отзывов клиентов
    class ClientReviewsController < ApiController
      def index
        json_response(ClientReview.all)
      end
    end
  end
end
