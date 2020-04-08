# frozen_string_literal: true

module Barion
  module Models
    # Transaction model implementation
    # API structure: https://docs.barion.com/PaymentTransaction
    class PaymentTransaction
      # TODO: validate [payee] to exist and activated Barion wallet
      attr_accessor :POS_transaction_id, :payee, :total, :comment,
                    :items, :payee_transactions

      def initialize(payee)
        self.POS_transaction_id = payee.gsub(/[@._-]/, '') +
                                  Time.current.strftime('%Y%m%d%H%M%S%L').to_s
        self.payee = payee
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
        payee_transactions&.map { |pt| arr.push(pt.api_json_format) }
        arr
      end

      def api_json_format
        {
          'POSTransactionId': self.POS_transaction_id,
          'Payee': payee,
          'Total': total,
          'Comment': comment,
          'PayeeTransactions': payee_transactions_json,
          'Items': items_json
        }.delete_if { |_, val| val.blank? }
      end
    end
  end
end
