# frozen_string_literal: true

module JsonApiSerializers
  module Seo
    # Сериализатор для SEO категорий. Для приложения СЕО.
    class CategorySerializer
      include FastJsonapi::ObjectSerializer

      set_key_transform :camel_lower

      attributes :title, :seo_text, :seo_text2, :slug,
                 :seo_title, :seo_description,
                 :parent_id, :depth_level,
                 :users_count

      attribute :personal_color do |cat|
        "##{cat.personal_color}"
      end

      attribute :icon do |cat|
        cat.icon&.file&.url
      end

      attribute :cover_image do |cat|
        cat.cover_image&.file&.url
      end

      belongs_to :category
      has_many :children
    end
  end
end
