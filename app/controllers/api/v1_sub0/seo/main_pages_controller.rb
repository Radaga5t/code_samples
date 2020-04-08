# frozen_string_literal: true

module Api
  module V1Sub0
    module Seo
      # SEO entities controller
      class MainPagesController < SeoController
        before_action :set_serializer

        def show
          json_response(::Seo::MainPage.last)
        end

        private

        def set_serializer
          @jsonapi_serializer = 'Seo::MainPageSerializer'
        end
      end
    end
  end
end
