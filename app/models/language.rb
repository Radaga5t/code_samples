# frozen_string_literal: true

# Модель Язык
class Language < ApplicationRecord
  translates :name
  accepts_nested_attributes_for :translations

  globalize_accessors locales: I18n.available_locales, attributes: [:name]

  has_and_belongs_to_many :users
  has_and_belongs_to_many :tasks

  default_scope -> { order(code: :asc) }
end
