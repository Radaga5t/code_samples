# frozen_string_literal: true

module UserNotifications
  # Уведомление по email
  class Email < UserNotification
    after_commit :send_email, on: :create

    enum status: {
      created: 0,
      in_progress: 1,
      failed: 2,
      delivered: 3
    }

    def need_to_deliver?
      created? || failed?
    end

    private

    def send_email
      NotificationWorkers::EmailNotificationsWorker.perform_async(id)
    end
  end
end
