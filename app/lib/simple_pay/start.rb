# frozen_string_literal: true

module SimplePay
  # Payment transaction beginning
  class Start < Base
    # DATA REQUIRED TO INITIATE TRANSACTION
    # merchant: the unique identifier of the merchant account in the SimplePay system.
    # orderRef: unique transaction identifier in the merchant system
    # customer: name of the customer
    # customerEmail: email address of the customer
    # language: the language of the payment page
    # currency: the currency of the transaction
    # total: the amount of the transaction
    # salt: 32-character long random string
    # methods: array of the payment method
    # invoice: array for the invoicing data
    # delivery: array for the delivery data
    # timeout: the time for which the transaction is valid, i.e. the time to initiate the payment
    # url:  the redirect URL where the merchant wants to redirect  the customer after the payment
    # sdkVersion: the version number of the payment module in the merchant system
    API_INTERFACE = :start

    def initialize(**args)
      %i[order_ref customer total].each do |arg|
        raise "No #{arg} passed" if args[arg].blank?
      end

      customer = args[:customer]
      order_ref = "Qjob:#{Rails.env}:#{args[:order_ref]}"

      self.currency = args[:currency] ? args[:currency].to_s.upcase : CURRENCY
      self.language = args[:language] ? args[:language].to_s.upcase : LANGUAGE

      self.transaction_data = {
        merchant: merchant,
        orderRef: order_ref,
        customer: customer[:name].to_s,
        customerEmail: customer[:email].to_s,
        language: language,
        currency: currency,
        total: args[:total],
        salt: salt,
        methods: [
          PAYMENT_METHODS[:card]
        ],
        # Optional: [invoice = {}] and [delivery = {}]
        url: URLS[:back],
        sdkVersion: SDK_VERSION
      }
    end

    def run
      exec_api_call
    end
  end
end
