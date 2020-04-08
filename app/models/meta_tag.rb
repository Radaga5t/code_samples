# frozen_string_literal: true

# Модель мета-тегов
class MetaTag < ApplicationRecord
  translates :title, :description, :keywords

  belongs_to :has_meta_tags, polymorphic: true, touch: true

  accepts_nested_attributes_for :translations, allow_destroy: true
end
