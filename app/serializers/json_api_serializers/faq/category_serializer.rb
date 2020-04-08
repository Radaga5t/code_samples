# frozen_string_literal: true

module JsonApiSerializers
  module Faq
    # FAQ's categories serializer
    class CategorySerializer
      include FastJsonapi::ObjectSerializer

      set_key_transform :camel_lower

      attributes :title, :slug, :parent_id, :depth_level, :personal_color

      attribute :icon do |record|
        ActionController::Base.helpers.image_url(record.icon.file.url) if record.icon.present?
      end

      has_many :pages
    end
  end
end
