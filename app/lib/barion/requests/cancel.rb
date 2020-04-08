# frozen_string_literal: true

module Barion
  module Requests
    # Cancel payment transaction
    # API request structure: https://docs.barion.com/Payment-CancelAuthorization-v2
    class Cancel < Barion::BaseRequest
      API_INTERFACE = :cancel_authorization

      attr_accessor :POS_key, :payment_id

      def initialize(payment_id)
        self.POS_key = Barion::POS_KEY
        self.payment_id = payment_id
      end
      
      def to_json
        {
          'POSKey': self.POS_key,
          'PaymentId': payment_id,
        }.to_json
      end
    end
  end
end
