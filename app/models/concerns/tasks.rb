# frozen_string_literal: true

# Модуль с бизнес логикой заданий
module Tasks
  # Модуль с классами ошибок в заданиях
  module Errors
    class WhoPaysNotSet < StandardError; end
    class WhoPaysReadOnly < StandardError; end
    class NoSingleOfferService < StandardError; end
    class TaskTemplateNotSet < StandardError; end
    class NoTaskResponseSelected < StandardError; end
  end
end
