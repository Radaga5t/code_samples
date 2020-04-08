# frozen_string_literal: true

module UserNotifications
  # Уведомление на сайте
  class Site < UserNotification
    after_commit :send_notification, on: :create

    enum status: {
      created: 0,
      in_progress: 1,
      delivered: 2,
      viewed: 3
    }

    def self.all_by_user(user)
      self.for_user(user)
          .includes(:notification_event, :user, :translations)
          .order(created_at: :desc)
    end

    def self.unread_by_user(user)
      self.for_user(user).where.not(status: UserNotifications::Site.statuses[:viewed])
    end

    def need_to_deliver?
      created?
    end

    def render
      self.title = interpolate_string(
        send("title_#{user.locale}")
      )
      self.message = interpolate_string(
        send("message_#{user.locale}")
      )
      self
    end

    def delivered!
      self.status = 'delivered'
      self.delivered_at = Time.current
      save
    end

    def viewed!
      self.status = 'viewed'
      self.viewed_at = Time.current
      save
    end

    private

    def send_notification
      NotificationWorkers::SiteNotificationsWorker.perform_async(id)
    end
  end
end
