# frozen_string_literal: true

module SimplePay
  # Managing refunds
  class Refund < Base
    API_INTERFACE = :refund

    def initialize(order_ref, transaction_id, refund_total)
      self.transaction_data = {
        salt: salt,
        merchant: merchant,
        orderRef: order_ref,
        transactionId: transaction_id,
        refundTotal: refund_total,
        currency: currency,
        sdkVersion: SDK_VERSION
      }
    end

    def run
      exec_api_call
    end
  end
end
