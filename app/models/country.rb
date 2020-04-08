# frozen_string_literal: true

# Модель Стран
class Country < ApplicationRecord
  translates :name
  accepts_nested_attributes_for :translations

  globalize_accessors locales: I18n.available_locales,
                      attributes: [:name]

  has_many :users, dependent: :nullify
end
