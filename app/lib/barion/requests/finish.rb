# frozen_string_literal: true

module Barion
  module Requests
    # Finish reserved transaction
    # API request structure: https://docs.barion.com/Payment-Start-v2
    class Finish < Barion::BaseRequest
      API_INTERFACE = :finish_reservation

      attr_accessor :payment_id, :transactions

      def initialize(payment_id)
        self.POS_key = Barion::POS_KEY
        self.payment_id = payment_id
      end

      def add_transaction(transaction)
        self.transactions ||= []
        self.transactions.push(transaction)
      end

      def add_transactions(transactions)
        transactions.map { |tr| self.transactions.push(tr) }
      end

      def transactions_json
        arr = []
        transactions.map { |t| arr.push(t.api_json_format) }
        arr
      end

      def to_json
        {
          'POSKey': self.POS_key,
          'PaymentId': payment_id,
          'Transactions': transactions_json
        }.to_json
      end
    end
  end
end
