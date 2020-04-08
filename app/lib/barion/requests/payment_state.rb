# frozen_string_literal: true

module Barion
  module Requests
    # Initialize new transaction API request
    # API request structure: https://docs.barion.com/Payment-GetPaymentState-v2
    class PaymentState < Barion::BaseRequest
      API_INTERFACE = :payment_state

      attr_accessor :payment_id

      def initialize(payment_id)
        self.POS_key = Barion::POS_KEY
        self.payment_id = payment_id
      end

      def to_json
        {
          'POSKey': self.POS_key,
          'PaymentId': payment_id
        }.to_json
      end
    end
  end
end
