# frozen_string_literal: true

module SimplePay
  # Handling API request after Start
  class Back < Base
    # API request
    attr_accessor :r, :s, :status, :simplepay_transaction_id, :transaction_id

    def initialize(r, s)
      # r - encoded JSON string, that consists of:
      # r: response code (response code)
      # t: SimplePay identifier of the transaction (transaction id)
      # e: event (event), can be %w[SUCCESS FAIL TIMEOUT CANCEL] or error codes
      # m: identifier of the merchant account (merchant)
      # o: transaction identifier of the merchant (order id)
      self.r = JSON.parse(Base64.decode64(r))
      self.s = s.gsub(' ', '+')

      # Status of the transaction (API request's ['e'] value)
      # can be %w[SUCCESS FAIL TIMEOUT CANCEL] or error codes
      self.status = self.r['e']

      # Transaction's ID in SimplePay system
      self.simplepay_transaction_id = self.r['t']

      # Order reference (our transaction ID stored in DB)
      self.transaction_id = self.r['o']
    end

    def back_signature_valid?
      Signature.check(r, s, merchant_key)
    end

    def transaction_success?
      status == 'SUCCESS'
    end
  end
end
