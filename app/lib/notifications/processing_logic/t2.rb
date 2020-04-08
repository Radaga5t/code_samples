# frozen_string_literal: true

module Notifications
  module ProcessingLogic
    # == T2 Новое предложение к заданию
    # === Атрибуты события:
    # - +subject+ - Task
    # - +target+ - TaskResponse
    #
    # === Адресат сообщений
    # - Заказчик задания
    #
    module T2
      def processing_logic
        user = subject.user
        not_create = []

        not_create.push(:email) unless subject.send_email_notifications && user.confirmed?
        not_create.push(:viber) unless subject.send_viber_notifications

        UserNotification.for_user(user)
                        .where(subject: subject)
                        .destroy_all

        Notifications::Builder.create_notifications(notification_event: self,
                                                    user: user,
                                                    not: not_create)
      end
    end
  end
end
