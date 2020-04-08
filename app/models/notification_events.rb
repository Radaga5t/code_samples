# frozen_string_literal: true

# Модуль с имплементацией типов событий для уведомлений
module NotificationEvents
  Dir[Rails.root.join('app', 'lib', 'notifications',
                      'processing_logic', '*.rb')]
    .each { |file| require_dependency file }

  require_dependency 'notification_events/notification_event_type'
end
