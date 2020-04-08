# frozen_string_literal: true

module Api
  module V1Sub0
    # Контроллер для промо-видео/ссылок на блог на главной
    class PromoArticlesController < ApiController
      def index
        json_response(PromoArticle.order(created_at: :desc).all)
      end
    end
  end
end
