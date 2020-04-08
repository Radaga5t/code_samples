# frozen_string_literal: true

# Модель промокода
class Promocode < ApplicationRecord
  translates :description

  accepts_nested_attributes_for :translations, allow_destroy: true

  monetize :amount_cents, allow_nil: true

  # может иметь привязанные услуги пользователя
  has_many :user_services,
           dependent: :nullify,
           inverse_of: :promocode

  enum type_of_discount: {
    relative: 0,
    absolute: 1
  }

  scope :active, lambda {
    where('(active_until IS NULL OR timestamp ? <= active_until) AND
           (max_count_of_uses = 0 OR max_count_of_uses > count_of_uses)',
          Time.current)
  }

  scope :active_for_user_account, lambda { |user_account|
      where
        .not('id in (?)', user_account.user_services.pluck(:promocode_id).uniq.compact)
        .where('
          (promocodes.active_until IS NULL OR timestamp ? <= promocodes.active_until) AND
          (promocodes.max_count_of_uses = 0 OR promocodes.max_count_of_uses > promocodes.count_of_uses)', Time.current
        )
  }

  validates :max_count_of_uses,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  validates :max_count_of_uses, presence: true, if: -> { active_until.nil? }
  validates :active_until,
            presence: true,
            if: -> { max_count_of_uses.nil? || max_count_of_uses.zero? }

  validates :count_of_uses,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  validates :relative_amount,
            allow_nil: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            }

  validates :label, presence: true, uniqueness: true

  validates :relative_amount, presence: true, if: -> { relative? }
  validates :amount_cents, presence: true, if: -> { absolute? }

  # Активность промокода. Возвращает +true+, если дата завершения активности
  # +active_until+ в будущем, и максимальное количество использования (если
  # задано) больше текущего количества использований. Возвращает +false+,
  # если не задана дата завершения активности и максимальное количество
  # использований равно 0
  # @return [Boolean]
  def active?
    return false if active_until.blank? && max_count_of_uses.zero?

    (active_until.blank? || active_until >= Time.current) &&
      (max_count_of_uses.zero? || max_count_of_uses >= count_of_uses)
  end

  # рассчитывает значение с учетом скидки, если промокод не активен,
  # возвращается изначальное значение
  # @param value [Money]
  # @return [Money]
  def discounted_value(value)
    return value unless active?

    if absolute?
      value - amount
    else
      value - (value * relative_amount / 100)
    end
  end
end
