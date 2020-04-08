# frozen_string_literal: true

module NotificationWorkers
  # Воркер для отправки E-mail сообщений
  class EmailNotificationsWorker
    include Sidekiq::Worker

    sidekiq_options queue: :mailers, retry: 2, backtrace: true

    def perform(id)
      globalize_fix
      notification = UserNotifications::Email.find_by(id: id)

      return true if notification.blank? || !notification.need_to_deliver?

      I18n.locale = notification.user.locale
      deliver_email_for notification
    end

    private

    def deliver_email_for(notification)
      UserNotificationsMailer.with(notification_id: notification.id)
                             .notify
                             .deliver
    rescue
      notification.failed!
      raise
    else
      notification.delivered_at = Time.current
      notification.delivered!
    end

    def globalize_fix
      storage = RequestStore.store
      return if storage[:globalize_fallbacks].present?

      fallback_hash = HashWithIndifferentAccess.new
      { en: %i[en hu ru], hu: %i[hu en ru], ru: %i[ru hu en] }.each do |key, value|
        fallback_hash[key] = value.presence || [key]
      end
      storage[:globalize_fallbacks] = fallback_hash
    end
  end
end
