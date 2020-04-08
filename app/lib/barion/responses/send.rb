# frozen_string_literal: true

module Barion
  module Responses
    # API response after sending money
    class Send
      attr_accessor :transaction_id, :currency, :amount, :from_balance,
                    :from_name, :to_name, :comment, :transaction_type,
                    :direction, :errors
      
      # api_response [Faraday::Response]
      def initialize(api_response)
        from_api_json(JSON.parse(api_response.body))
      end

      private

      def from_api_json(api_json)
        self.transaction_id = api_json['TransactionId']
        self.currency = api_json['Currency']
        self.amount = api_json['Amount']
        self.from_balance = api_json['FromBalance']
        self.from_name = api_json['FromName']
        self.to_name = api_json['ToName']
        self.comment = api_json['Comment']
        self.transaction_type = api_json['TransactionType']
        self.direction = api_json['Direction']
        self.errors = api_json['Errors']
      end
    end
  end
end
