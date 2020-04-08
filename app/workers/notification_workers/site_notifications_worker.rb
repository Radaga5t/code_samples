# frozen_string_literal: true

module NotificationWorkers
  # Воркер для отправки сообщений на сайте
  class SiteNotificationsWorker
    include Sidekiq::Worker

    sidekiq_options queue: :mailers, retry: 2, backtrace: true

    def perform(id)
      globalize_fix
      notification = UserNotifications::Site.find_by(id: id)

      return true if notification.blank? || !notification.need_to_deliver?

      I18n.locale = notification.user.locale
      deliver_notification notification
    end

    private

    def deliver_notification(notification)
      notification = notification.render
      user = User.fast_find(notification.user_id)
      unread = UserNotifications::Site.unread_by_user(user).size

      NotificationsChannel.send_event_to_client(
        user,
        'new_notification',
        'notification',
        notification: JsonApiSerializers::UserNotifications::SiteSerializer.new(notification, is_collection: false),
        unread: unread
      )
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
