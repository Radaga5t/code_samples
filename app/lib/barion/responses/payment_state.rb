# frozen_string_literal: true

module Barion
  module Responses
    # API response about payment state
    class PaymentState < Barion::BaseResponse
      attr_accessor :payment_id, :payment_request_id, :POS_id, :POS_name,
                    :POS_owner_email, :status, :payment_type,
                    :allowed_funding_sources, :funding_source,
                    :funding_information, :guest_checkout, :created_at,
                    :started_at, :completed_at, :valid_until, :reserved_until,
                    :delayed_capture_until, :transactions, :total, :currency,
                    :suggested_locale, :fraud_risk_score, :callback_url,
                    :redirect_url

      # api_response [Faraday::Response]
      def initialize(api_response)
        from_api_json(JSON.parse(api_response.body))
      end

      private

      def from_api_json(api_json)
        self.payment_id = api_json['PaymentId']
        self.payment_request_id = api_json['PaymentRequestId']
        self.POS_id = api_json['POSId']
        self.POS_name = api_json['POSName']
        self.POS_owner_email = api_json['POSOwnerEmail']
        self.status = api_json['Status']
        self.payment_type = api_json['PaymentType']
        self.allowed_funding_sources = api_json['AllowedFundingSources']
        self.funding_source = api_json['FundingSource']
        self.funding_information = api_json['FundingInformation']
        self.guest_checkout = api_json['GuestCheckout']
        self.created_at = api_json['CreatedAt']
        self.started_at = api_json['StartedAt']
        self.completed_at = api_json['CompletedAt']
        self.valid_until = api_json['ValidUntil']
        self.reserved_until = api_json['ReservedUntil']
        self.delayed_capture_until = api_json['DelayedCaptureUntil']
        self.transactions = api_json['Transactions']
        self.total = api_json['Total']
        self.currency = api_json['Currency']
        self.suggested_locale = api_json['SuggestedLocale']
        self.fraud_risk_score = api_json['FraudRiskScore']
        self.callback_url = api_json['CallbackUrl']
        self.redirect_url = api_json['RedirectUrl']
      end
    end
  end
end
