# frozen_string_literal: true

module UserNotifications
  # Уведомление через Viber
  class Viber < UserNotification
    after_commit :send_message, on: :create

    enum status: {
      created: 0,
      in_progress: 1,
      delivered: 2
    }

    def delivered!
      self.status = :delivered
      self.delivered_at = Time.current
      save
    end

    private

    def send_message
      NotificationWorkers::ViberNotificationsWorker.perform_async(id)
    end
  end
end
