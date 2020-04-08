# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для ресурса languages
    class LanguagesController < ApiController
      def index
        json_response(Language.includes(:translations).all)
      end
    end
  end
end
