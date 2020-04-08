# frozen_string_literal: true

module Seo
  # Категории для SEO-приложения (отличные от основных)
  class Category < ApplicationRecord
    include HasSlugCode
    include HasAssets

    attr_accessor :users_count

    before_save :set_depth_level, on: %i[create update]

    translates :title, :description, :seo_text, :seo_text2

    parameterize_column :title
    accepts_nested_attributes_for :translations

    has_many :children,
             class_name: 'Seo::Category',
             foreign_key: 'parent_id',
             inverse_of: :parent

    belongs_to :parent,
               class_name: 'Seo::Category',
               optional: true,
               inverse_of: :children

    belongs_to :category,
               class_name: '::Category'

    image_asset :icon
    image_asset :cover_image

    private

    def set_depth_level
      self.depth_level = parent.depth_level + 1 if parent.present?
    end
  end
end
