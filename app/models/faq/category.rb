# frozen_string_literal: true

module Faq
  # FAQ Category model
  class Category < ApplicationRecord
    include HasAssets
    include HasSlugCode

    translates :title
    globalize_accessors locales: I18n.available_locales,
                        attributes: %i[title]

    accepts_nested_attributes_for :translations, allow_destroy: true
    parameterize_column :title

    has_many :children,
             class_name: 'Faq::Category',
             foreign_key: 'parent_id',
             dependent: :destroy,
             inverse_of: :parent

    belongs_to :parent,
               class_name: 'Faq::Category',
               optional: true,
               inverse_of: :children

    has_many :pages,
             class_name: 'Faq::Page',
             dependent: :destroy

    image_asset :icon

    before_save :set_depth_level

    private

    def set_depth_level
      self.depth_level = parent.depth_level + 1 if parent
    end
  end
end
