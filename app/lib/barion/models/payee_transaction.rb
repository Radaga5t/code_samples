# frozen_string_literal: true

module Barion
  module Models
    # Transaction model implementation
    # API structure: https://docs.barion.com/PaymentTransaction
    class PayeeTransaction
      # TODO: validate [payee] to exist and activated Barion wallet
      attr_accessor :POS_transaction_id, :payee, :total, :comment

      def initialize(payee, total)
        # TODO: change ID generation differ from PaymentTransaction
        self.POS_transaction_id = payee.gsub(/[@._-]/, '') +
                                  Time.current.strftime('%Y%m%d%H%M%S%L').to_s

        self.payee = payee
        self.total = total
      end

      def api_json_format
        {
          'POSTransactionId': self.POS_transaction_id,
          'Payee': payee,
          'Total': total,
          'Comment': comment
        }.delete_if { |_, val| val.nil? }
      end
    end
  end
end
