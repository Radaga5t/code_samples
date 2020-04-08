# frozen_string_literal: true

module Barion
  module Requests
    # Initialize new transaction API request
    # API request structure: https://docs.barion.com/Payment-Start-v2
    class Start < Barion::BaseRequest
      API_INTERFACE = :start

      attr_accessor :payment_type,
                    :reservation_period,
                    :delayed_capture_period,
                    :payment_window,
                    :guest_checkout,
                    :funding_sources,
                    :payment_request_id,
                    :payer_hint,
                    :transactions,
                    :locale,
                    :order_number,
                    :shipping_address,
                    :billing_address,
                    :initiate_recurrence,
                    :recurrence_id,
                    :redirect_url,
                    :callback_url,
                    :currency,
                    :card_holder_name_hint,
                    :payer_phone_number,
                    :payer_work_phone_number,
                    :payer_home_phone_number,
                    :payer_account_information,
                    :purchase_information,
                    :reccurence_type,
                    :challenge_prefference

      def initialize(**params)
        self.POS_key = Barion::POS_KEY
        self.payment_type = Barion::PAYMENT_TYPES[params[:type]] || Barion::PAYMENT_TYPES[:immediate]

        if payment_type == Barion::PAYMENT_TYPES[:reservation]
          self.reservation_period = params[:reservation_period] || '1:00:00:00'
        end

        if payment_type == Barion::PAYMENT_TYPES[:delayed]
          self.delayed_capture_period = params[:delayed_period] || '3:00:00:00'
        end

        self.payment_window = params[:payment_window] || '1:00:00'
        self.funding_sources = params[:funding_sources] || ['ALL']
        self.locale = params[:locale] || Barion::LOCALES[:en]
        self.currency = params[:currency] || Barion::CURRENCY[:huf]

        self.callback_url = params[:callback_url] || CALLBACK_URL
        self.redirect_url = params[:redirect_url] || REDIRECT_URL

        self.guest_checkout = params[:guest_checkout] || true
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
          'PaymentType': self.payment_type,
          'ReservationPeriod': self.reservation_period,
          'DelayedCapturePeriod': self.delayed_capture_period,
          'PaymentWindow': self.payment_window,
          'GuestCheckout': self.guest_checkout,
          'FundingSources': self.funding_sources,
          'PaymentRequestId': self.payment_request_id,
          'PayerHint': self.payer_hint,
          'Transactions': transactions_json,
          'Locale': self.locale,
          'OrderNumber': self.order_number,
          'ShippingAddress': self.shipping_address,
          'BillingAddress': self.billing_address,
          'InitiateRecurrence': self.initiate_recurrence,
          'RecurrenceId': self.recurrence_id,
          'RedirectUrl': self.redirect_url,
          'CallbackUrl': self.callback_url,
          'Currency': self.currency,
          'CardHolderNameHint': self.card_holder_name_hint,
          'PayerPhoneNumber': self.payer_phone_number,
          'PayerWorkPhoneNumber': self.payer_work_phone_number,
          'PayerHomePhoneNumber': self.payer_home_phone_number,
          'PayerAccountInformation': self.payer_account_information,
          'PurchaseInformation': self.purchase_information,
          'ReccurenceType': self.reccurence_type,
          'ChallengePrefference': self.challenge_prefference
        }.delete_if { |_, val| val.nil? }.to_json
      end
    end
  end
end
