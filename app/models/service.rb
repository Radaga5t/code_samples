# frozen_string_literal: true

# Модель Услуги
# от нее необходимо наследоваться для реализации конкретного типа услуги
# Имплементации Услуг находятся в модуле +Services+,
# использовать экземпляры модели +Service+ напрямую нельзя
class Service < ApplicationRecord
  translates :name, :description

  globalize_accessors locales: I18n.available_locales,
                      attributes: %i[name description]

  monetize :price_cents,
           numericality: {
             greater_than_or_equal_to: 0
           }

  # не может быть инициализирован без указания конкретного типа услуги
  validates :type, presence: true
end
