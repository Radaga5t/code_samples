# frozen_string_literal: true

# Модель Ассетов, конкретные типы ассетов должны быть созданы в
# в директории ./assets/ и унаследованы от этого класса
class Asset < ApplicationRecord
  belongs_to :host, polymorphic: true, touch: true

  # не может быть инициализирован без указания конкретного типа ассета
  validates :type, presence: true

  default_scope -> { order(sort: :asc) }

  ## название файла для админки
  def label_for_rails_admin
    return '' if file.blank?

    "#{original_name} (#{ActiveSupport::NumberHelper
                          .number_to_human_size(file_size)})"
  end
end
