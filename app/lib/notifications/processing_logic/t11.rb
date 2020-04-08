# frozen_string_literal: true

module Notifications
  module ProcessingLogic
    # == T11 Вам отправлено предложение на выполнение задания
    # === Атрибуты события:
    # - +subject+ - Task
    # - +target+ - TaskOffer
    #
    # === Адресат сообщений
    # - TaskOffer.user - пользователь, которому предложили выполнить задание
    module T11
      def processing_logic
        user = target.user
        not_create = []

        not_create.push(:email) unless user.subscribe_to_system_messages && user.confirmed?

        Notifications::Builder.create_notifications(notification_event: self,
                                                    user: user,
                                                    not: not_create)
      end
    end
  end
end
