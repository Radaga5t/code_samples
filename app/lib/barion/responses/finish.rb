# frozen_string_literal: true

module Barion
  module Responses
    # API response after reserved transaction finished
    class Finish < Barion::BaseResponse
      attr_accessor :is_successful, :payment_id, :payment_request_id,
                    :status, :transactions, :errors

      # api_response [Faraday::Response]
      def initialize(api_response)
        from_api_json(JSON.parse(api_response.body))
      end

      private

      def from_api_json(api_json)
        self.is_successful = api_json['IsSuccessful']
        self.payment_id = api_json['PaymentId']
        self.payment_request_id = api_json['PaymentRequestId']
        self.status = api_json['Status']
        self.transactions = api_json['Transactions']
        self.errors = api_json['Errors']
      end
    end
  end
end
