# frozen_string_literal: true

module SimplePay
  # Qjob specified module for SimplePay payments
  module Qjob
    extend self

    def top_up_balance(
      order_ref: nil,
      total: nil,
      customer: nil
    )
      SimplePay::Start.new(
        order_ref: order_ref,
        language: I18n.locale,
        total: total,
        customer: {
          name: customer.fullname,
          email: customer.email
        }
      ).run
    end
  end
end
