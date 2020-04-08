# frozen_string_literal: true

module JsonApiSerializers
  module Seo
    # Сериализатор для исполнителей. Для приложения СЕО.
    class MainPageSerializer
      include FastJsonapi::ObjectSerializer

      set_key_transform :camel_lower

      attributes :title, :description, :seo_title, :seo_description, :seo_text

      attribute :cover_image do |page|
        page.cover_image&.file&.url
      end

      attribute :og_image do |page|
        page.og_image&.file&.url
      end
    end
  end
end
