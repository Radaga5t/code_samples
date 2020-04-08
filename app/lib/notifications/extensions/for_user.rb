# frozen_string_literal: true

module Notifications
  module Extensions
    # Класс для подключения нотификаций к модели пользователя
    class ForUser < DefaultExtension
      include Singleton

      def listen
        listen_to_after_confirmation
        listen_to_after_become_executor
      end

      def after_confirmation_listener(instance)
        perform.u3_trigger(instance)
      end

      def after_become_executor_listener(instance)
        perform.u4_trigger(instance)
      end

      def u3_trigger(instance)
        create_event(:U3, instance)
      end

      def u4_trigger(instance)
        create_event(:U4, instance) if instance.executor?
      end
    end
  end
end
