# frozen_string_literal: true

module Notifications
  module ProcessingLogic
    # == T10 В задании был выбран другой исполнитель
    # === Атрибуты события:
    # - +subject+ - Task
    # - +target+ - TaskResponse
    #
    # === Адресат сообщений
    # - Все пользователи, которые подписались на уведомления при отклике на задание
    # - и которые не были выбраны как исполнители
    module T10
      def processing_logic
        responses = TaskResponse.where(task: subject)
                                .where.not(user: target.user)

        responses.each do |tr|
          not_create = []

          not_create.push(:email) unless tr.user.subscribe_to_system_messages && tr.user.confirmed?

          Notifications::Builder.create_notifications(notification_event: self,
                                                      user: tr.user,
                                                      not: not_create)
        end
      end
    end
  end
end
