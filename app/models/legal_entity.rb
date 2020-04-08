# frozen_string_literal: true

# Модель данных юридического лица
class LegalEntity < ApplicationRecord
  belongs_to :user, touch: true
end
