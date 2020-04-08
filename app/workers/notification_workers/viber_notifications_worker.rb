# frozen_string_literal: true

module NotificationWorkers
  # Воркер для отправки уведомлений в Viber
  class ViberNotificationsWorker
    include Sidekiq::Worker

    sidekiq_options queue: :mailers, retry: 2, backtrace: true

    def perform(id)
      globalize_fix
      notification = UserNotifications::Viber.find_by(id: id)

      return true if notification.blank?

      I18n.locale = notification.user.locale
      deliver_notification notification
    end

    private

    def deliver_notification(notification)
      return if Rails.env.test?

      viber_params = {
        message: notification.interpolate_string(notification.message),
        button_link: "#{ENV['PROTOCOL']}://#{ENV['HOST']}/tasks/#{notification.subject.id}",
        button_text: I18n.t('sendpulse.viber.button_text')
      }

      response = Sendpulse::API.viber_send(notification.user.phone.to_i, viber_params)
      notification.delivered! unless response[:is_error]
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
