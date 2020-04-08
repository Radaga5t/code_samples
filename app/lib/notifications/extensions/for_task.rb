# frozen_string_literal: true

module Notifications
  module Extensions
    # Класс для подключения нотификаций к модели задания
    class ForTask < DefaultExtension
      include Singleton

      def listen
        listen_to_after_publish
      end

      ## listeners

      def after_publish_listener(instance)
        perform.t1_trigger(instance)
        perform.t7_trigger(instance)
      end

      ## triggers

      def t1_trigger(instance)
        create_event(:T1, instance)
      end

      def t7_trigger(instance)
        return unless UserFavoriteCategory.with_subscription.exists?

        create_event(:T7, instance, target: instance.category)
      end
    end
  end
end
