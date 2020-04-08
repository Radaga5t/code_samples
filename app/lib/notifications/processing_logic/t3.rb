# frozen_string_literal: true

module Notifications
  module ProcessingLogic
    # == Т3 Исполнитель отметил, что не выполнил задание и оставил отзыв
    # === Атрибуты события:
    # - +subject+ - Task
    # - +target+ - UserReview
    #
    # === Адресат сообщений
    # - Заказчик задания
    #
    module T3
      def processing_logic
        user = target.target_user
        not_create = []

        not_create.push(:email) unless user.subscribe_to_system_messages && user.confirmed?

        Notifications::Builder.create_notifications(notification_event: self,
                                                    user: user,
                                                    not: not_create)
      end
    end
  end
end
