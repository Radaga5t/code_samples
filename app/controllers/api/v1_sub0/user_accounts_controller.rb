# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса users/:userId/user_account
    class UserAccountsController < ApiController
      before_action :authenticate_user!
      after_action :verify_authorized

      def show
        account = policy_scope(UserAccount).first
        authorize account
        json_response(account)
      end

      def refill
        user_account = policy_scope(UserAccount).first
        authorize(user_account)
        amount = Money.new(refill_params[:amount], 'huf')
        transaction = user_account.refill(amount)
        transaction.start_payment(refill_params[:payment_system])

        json_response(transaction)
      end

      private

      def refill_params
        params.permit(:amount, :payment_system)
      end
    end
  end
end
