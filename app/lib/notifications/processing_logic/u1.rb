# frozen_string_literal: true

module Notifications
  module ProcessingLogic
    # Бизнес логика работы с событием U1
    module U1
      def processing_logic
        UserNotification.for_user(subject)
                        .where(subject: subject)
                        .destroy_all

        Notifications::Builder.create_notifications(notification_event: self,
                                                    user: subject)
      end
    end
  end
end
