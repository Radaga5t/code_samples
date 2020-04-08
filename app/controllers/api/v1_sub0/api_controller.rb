# frozen_string_literal: true

module Api
  module V1Sub0
    # Рутовый api контроллер для api версии 1.0
    class ApiController < ApplicationApiController
      after_action :add_index_headers, only: [:index]
      after_action :add_detail_headers, except: [:index]

      attr_accessor :api_ver
      attr_accessor :pagination_page
      attr_accessor :pagination_page_count
      attr_accessor :pagination_limit
      attr_accessor :pagination_item_count

      def initialize
        self.api_ver = '1.0'
      end

      def index
        render json: {
          api_ver: api_ver
        }
      end

      def show; end

      def new; end

      def create; end

      def edit; end

      def update; end

      def destroy; end

      protected

      # Добавляем общие заголовки для всех ответов API
      def add_common_headers
        response.headers['Api-Ver'] = api_ver
      end

      # Добавляем заголовки для списка элементов
      def add_index_headers
        add_common_headers
      end

      # Добавляем заголовки для элеметов
      def add_detail_headers
        add_common_headers
      end
    end
  end
end
