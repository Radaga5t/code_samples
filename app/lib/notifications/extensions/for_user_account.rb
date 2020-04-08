# frozen_string_literal: true

module Notifications
  module Extensions
    # Класс для подключения нотификаций к модели пользователя
    class ForUserAccount < DefaultExtension
      include Singleton
    end
  end
end
