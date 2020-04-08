# frozen_string_literal: true

module Payments
  module Barion
    # Barion webhooks handler
    # Allowed payment's statuses: https://docs.barion.com/PaymentStatus
    class BarionController < ApplicationController
      def refill
        ps = ::Barion::Qjob.payment_state params[:PaymentId]
        transaction = AccountTransactions::RefillTransaction.find(ps.payment_request_id)

        case ps.status
        when 'Succeeded'
          transaction.process
        when 'Failed' || 'Canceled'
          transaction.reject
        end

        render json: { "Status": transaction.status }
      end
    end
  end
end
