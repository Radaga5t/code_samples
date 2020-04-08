# frozen_string_literal: true

module Barion
  # Barion client adapted for QJob
  class Client
    def start_immediate(payee, item_data, config = {})
      transaction = Models::PaymentTransaction.new payee
      transaction.add_item Models::Item.new(item_data)

      start_request = Requests::Start.new type: :immediate
      start_request.add_transaction(transaction)

      config.map { |item, val| start_request.send("#{item}=", val) }

      api_response = Responses::Start.new start_request.run

      api_response
    end

    def start_delayed(payer, payee, item_data, config = {})
      transaction = Models::PaymentTransaction.new payee
      transaction.add_item Models::Item.new(item_data)

      payee_transaction = Models::PayeeTransaction.new QJOB_BARION_ACCOUNT, transaction.total * COMMISSION
      transaction.add_payee_transaction(payee_transaction)

      start_request = Requests::Start.new type: :delayed
      start_request.payment_request_id = 'PAY:' + payer.gsub(/[@._-]/, '') + '|' + payee.gsub(/[@._-]/, '')
      start_request.add_transaction(transaction)

      config.map { |item, val| start_request.send("#{item}=", val) }

      api_response = Responses::Start.new start_request.run

      api_response
    end

    def capture_delayed(item_data, params)
      %i[payment_id trans_id total payee_trans_id].each do |param|
        raise "Required param #{param} is not passed!" unless params[param]
      end

      transaction = Barion::Models::FinishTransaction.new params[:trans_id]
      transaction.add_item Models::Item.new(item_data)

      comission = params[:comission] || Barion::COMMISSION
      payee_total = params[:total] * comission
      payee_transaction = Barion::Models::FinishPayeeTransaction.new params[:payee_trans_id],
                                                                     payee_total
      transaction.add_payee_transaction(payee_transaction)

      capture_request = Barion::Requests::Capture.new params[:payment_id]
      capture_request.add_transaction(transaction)

      api_response = Barion::Responses::Capture.new capture_request.run

      api_response
    end

    def start_reservation(payer, payee, item_data, config = {})
      transaction = Models::PaymentTransaction.new payee
      transaction.add_item Models::Item.new(item_data)

      payee_transaction = Models::PayeeTransaction.new QJOB_BARION_ACCOUNT, transaction.total * COMMISSION
      transaction.add_payee_transaction(payee_transaction)

      start_request = Requests::Start.new type: :reservation
      start_request.payment_request_id = 'PAY:' + payer.gsub(/[@._-]/, '') + '|' + payee.gsub(/[@._-]/, '')
      start_request.add_transaction(transaction)

      config.map { |item, val| start_request.send("#{item}=", val) }

      api_response = Responses::Start.new start_request.run

      api_response
    end

    def finish_reservation(item_data, config)
      %i[payment_id trans_id total payee_trans_id].each do |param|
        raise "Required param #{param} is not passed!" unless config[param]
      end

      transaction = Models::FinishTransaction.new config[:trans_id]
      transaction.add_item Models::Item.new(item_data)

      payee_transaction = Models::FinishPayeeTransaction.new config[:payee_trans_id],
                                                             transaction.total * COMMISSION
      transaction.add_payee_transaction(payee_transaction)

      finish_request = Requests::Finish.new config[:payment_id]
      finish_request.add_transaction(transaction)

      api_response = Responses::Finish.new finish_request.run

      api_response
    end

    def cancel(payment_id)
      cancel_request = Requests::Cancel.new payment_id

      api_response = Responses::Cancel.new cancel_request.run

      api_response
    end

    def payment_state(payment_id)
      state_request = Barion::Requests::PaymentState.new payment_id
      api_response = Barion::Responses::PaymentState.new state_request.run :get

      api_response
    end
  end
end
