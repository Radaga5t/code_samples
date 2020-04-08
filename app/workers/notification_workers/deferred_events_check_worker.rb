# frozen_string_literal: true

module NotificationWorkers
  # Воркер для проверки отложенных событий (если событие есть, а отложенного
  # задания в Sidekiq нет)
  class DeferredEventsCheckWorker
    include Sidekiq::Worker

    sidekiq_options queue: :low

    def perform
      NotificationEvent.deferred.each do |notification|
        check_job_for_deferred(notification)
      end
    end

    private

    def check_job_for_deferred(event)
      return unless event.deferred?

      if event.jid.present?
        ss = Sidekiq::ScheduledSet.new
        jobs = ss.select { |retri| retri.jid == event.jid }
        event.update_column(:jid, event.send(:perform_worker)) if jobs.empty?
      else
        event.update_column(:jid, event.send(:perform_worker))
      end
    end
  end
end
