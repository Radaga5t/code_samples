# frozen_string_literal: true

module Barion
  module Responses
    # API response after initialize transaction
    class Start < Barion::BaseResponse
      attr_accessor :payment_id, :payment_request_id,
                    :status, :QR_url, :recurrence_result,
                    :transactions, :gateway_url, :callback_url,
                    :redirect_url, :errors

      # api_response [Faraday::Response]
      def initialize(api_response)
        from_api_json(JSON.parse(api_response.body))
      end

      private

      def from_api_json(api_json)
        self.payment_id = api_json['PaymentId']
        self.payment_request_id = api_json['PaymentRequestId']
        self.status = api_json['Status']
        self.QR_url = api_json['QRUrl']
        self.recurrence_result = api_json['RecurrenceResult']
        self.transactions = api_json['Transactions']
        self.gateway_url = api_json['GatewayUrl']
        self.callback_url = api_json['CallbackUrl']
        self.redirect_url = api_json['RedirectUrl']
        self.errors = api_json['Errors']
      end
    end
  end
end
