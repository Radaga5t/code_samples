# frozen_string_literal: true

module Payments
  module SimplePay
    # SimplePay webhooks handler (IPN etc.)
    class SimplePayController < ApplicationController
      def ipn
        ipn = ::SimplePay::IPN.new request
        trans_id = ipn.transaction_data[:orderRef].split(':').last
        transaction = AccountTransactions::RefillTransaction.find trans_id
        case ipn.transaction_data[:status]
        when 'AUTHORIZED'
          transaction.authorize
        when 'FINISHED'
          transaction.process
        when 'FAIL'
          transaction.reject
        end

        # TODO: response depend on ipn.signature_valid? result
        response.set_header('Signature', ipn.signature)
        render json: ipn.transaction_data
      end

      def back
        r = params.dig(:r)
        s = params.dig(:s)
        back = ::SimplePay::Back.new(r, s) if r && s

        if back.present? && back.back_signature_valid?
          render json: back.r
        else
          render json: { errors: 'Invalid signature' }
        end
      end
    end
  end
end
