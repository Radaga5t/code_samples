# frozen_string_literal: true

module NotificationWorkers
  # Воркер для обработки событий

  class NotificationEventsWorker
    include Sidekiq::Worker

    sidekiq_options queue: :events

    def perform(type, id)
      globalize_fix
      event = type.constantize.find_by(id: id)
      return true if event.blank? || !event.ready_to_process?

      event.in_progress!
      event.process!
    end

    private

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
