# frozen_string_literal: true

module Barion
  module Models
    # Finish payee reserved transaction model
    # API structure: https://docs.barion.com/PayeeTransactionToFinishs
    class FinishPayeeTransaction
      attr_accessor :transaction_id, :total, :comment

      def initialize(transaction_id, total)
        self.transaction_id = transaction_id
        self.total = total
      end

      def api_json_format
        {
          'TransactionId': transaction_id,
          'Total': total,
          'Comment': comment
        }.delete_if { |_, val| val.nil? }
      end
    end
  end
end
