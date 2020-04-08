# frozen_string_literal: true

module Barion
  # Qjob's specifical requests
  module Qjob
    extend self

    def top_up_balance(
      total: nil,
      payment_request_id: nil
    )
      service = {
        name: 'Top up Qjob balance',
        description: 'Top up balance',
        quantity: total,
        unit: 'Ft',
        price: 1
      }

      config = {
        locale: LOCALES[I18n.locale],
        currency: CURRENCY[:huf],
        callback_url: CALLBACK_URL + '/refill',
        redirect_url: REDIRECT_URL,
        payment_request_id: payment_request_id
      }

      barion_client.start_immediate QJOB_BARION_ACCOUNT, service, config
    end

    def pay_task_publishing(task); end

    def pay_task_response(task); end

    def start_sbr(task)
      task_data = {
        name: task.title,
        description: task.category.title,
        quantity: 1,
        unit: 'Task',
        price: task.budget
      }

      config = {
        locale: LOCALES[task.user.locale],
        currency: CURRENCY[:huf],
        callback_url: CALLBACK_URL,
        redirect_url: REDIRECT_URL,
        reservation_period: '00:00:10:00'
      }

      barion_client.start_reservation task.user.email, 'ov.zhen@gmail.com', task_data, config
    end

    def finish_sbr(task); end

    def cancel_sbr(payment_id)
      barion_client.cancel payment_id
    end

    def payment_state(payment_id)
      barion_client.payment_state payment_id
    end

    def barion_client
      Barion::Client.new
    end

    def fake_task
      os = OpenStruct.new
      os.title = 'Test title'
      os.budget = 1000
      os.category = OpenStruct.new
      os.user = OpenStruct.new
      os.category.title = 'Test category title'
      os.user.email = 'eugene.ov@yandex.ru'
      os.user.locale = :en

      os
    end
  end
end
