# frozen_string_literal: true

module SimplePay
  # IPN Handler
  # Instant Payment Notification - POST request from API
  # This is the end of the successful transaction
  class IPN < Base
    API_INTERFACE = :start

    attr_accessor :request

    def initialize(request)
      self.request = request
      params = request.params

      self.transaction_data = {
        salt: params[:salt],
        orderRef: params[:orderRef],
        method: params[:method],
        merchant: params[:merchant],
        finishDate: params[:finishDate],
        paymentDate: params[:paymentDate],
        transactionId: params[:transactionId],
        status: params[:status],
        receiveDate: Time.now.iso8601
      }
    end

    def signature_valid?
      Signature.check(request.params[:simple_pay], request.headers['Signature'], merchant_key)
    end
  end
end
