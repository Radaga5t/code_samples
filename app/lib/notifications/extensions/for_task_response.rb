# frozen_string_literal: true

module Notifications
  module Extensions
    # Класс для подключения нотификаций к модели ответа на задание
    class ForTaskResponse < DefaultExtension
      include Singleton

      def listen
        listen_to_after_publish
        listen_to_after_select
      end

      ## listeners

      def after_publish_listener(instance)
        perform.t2_trigger(instance)
        perform.t8_trigger(instance)
      end

      def after_select_listener(instance)
        perform.t9_trigger(instance)
        perform.t10_trigger(instance)
      end

      ## triggers

      def t2_trigger(instance)
        create_event(:T2, instance.task, target: instance)
      end

      def t8_trigger(instance)
        return unless instance.user.task_responses.size == 1

        create_event(:T8, instance.task, target: instance)
      end

      def t9_trigger(instance)
        create_event(:T9, instance.task, target: instance)
      end

      def t10_trigger(instance)
        create_event(:T10, instance.task, target: instance)
      end
    end
  end
end
