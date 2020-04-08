# frozen_string_literal: true

module Api
  module V1Sub0
    module Seo
      # SEO Uniq cities
      class CitiesController < SeoController
        before_action :set_serializer

        def index
          json_response(::Seo::City.all)
        end

        def show
          json_response(::Seo::City.find_by(slug: params.dig(:slug)))
        end

        private

        def set_serializer
          @jsonapi_serializer = 'Seo::CitySerializer'
        end
      end
    end
  end
end
