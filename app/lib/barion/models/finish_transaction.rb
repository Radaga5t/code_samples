# frozen_string_literal: true

module Barion
  module Models
    # Transaction model implementation
    # API structure: https://docs.barion.com/TransactionToFinish
    class FinishTransaction
      # TODO: validate [payee] to exist and activated Barion wallet
      attr_accessor :transaction_id, :total, :comment,
                    :payee_transactions, :items

      def initialize(transaction_id)
        self.transaction_id = transaction_id

        self.total = 0
      end

      def add_item(item)
        self.items ||= []
        self.items.push(item)
        self.total += item.total
      end

      def add_items(items)
        items.map { |i| add_item(i) }
      end

      def add_payee_transaction(payee_transaction)
        self.payee_transactions ||= []
        payee_transactions.push(payee_transaction)
      end

      def add_payee_transactions
        payee_transactions.map { |t| add_payee_transactions(t) }
      end

      def items_json
        arr = []
        items.map { |i| arr.push(i.api_json_format) }
        arr
      end

      def payee_transactions_json
        arr = []
        payee_transactions.map { |pt| arr.push(pt.api_json_format) }
        arr
      end

      def api_json_format
        {
          'TransactionId': transaction_id,
          'Total': total,
          'Comment': comment,
          'PayeeTransactions': payee_transactions_json,
          'Items': items_json
        }.delete_if { |_, val| val.nil? }
      end
    end
  end
end
