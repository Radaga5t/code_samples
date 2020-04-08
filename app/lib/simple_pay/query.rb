# frozen_string_literal: true

module SimplePay
  # Transactions states
  class Query < Base
    API_INTERFACE = :query

    # [params] can includes two optional arrays
    # 1. [Array<string>] order_refs (our own unique transaction's ID)
    # 2. [Array<string>] transaction_ids (SimplePay transaction's ID)
    # Optional: [detailed] & [refunds] boolean params
    def initialize(**params)
      self.transaction_data = {
        salt: salt,
        merchant: merchant,
        sdkVersion: SDK_VERSION
      }

      transaction_data[:orderRefs] = params[:order_refs] if params[:order_refs].present?
      transaction_data[:transactionIds] = params[:transaction_ids] if params[:transaction_ids].present?

      transaction_data[:detailed] = true if params[:detailed] == true
      transaction_data[:refunds] = true if params[:refunds] == true
    end

    def run
      raise 'No transaction_ids or order_refs passed' if
        transaction_data[:orderRefs].blank? && transaction_data[:transactionIds].blank?

      exec_api_call
    end
  end
end
