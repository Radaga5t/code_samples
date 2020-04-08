# frozen_string_literal: true

# Модель Услуги пользователя,
# от нее необходимо наследоваться для реализации конкретного типа услуги
# Имплементации Услуг пользователя находятся в модуле Services,
# использовать экземпляры модели UserService напрямую нельзя
class UserService < ApplicationRecord
  belongs_to :user_account, -> { readonly },
             inverse_of: :user_services

  # может иметь привязанный промокод
  belongs_to :promocode,
             counter_cache: :count_of_uses,
             optional: true,
             inverse_of: :user_services

  # имеет транзакции покупки услуги
  has_one :service_activation_transaction,
          inverse_of: :user_service,
          dependent: :destroy,
          class_name: 'AccountTransactions::ServiceActivationTransaction',
          foreign_key: :user_service_id

  # не может быть инициализирован без указания конкретного типа
  # услуги пользователя
  validates :type, presence: true

  def active?; end

  def activate; end

  def promocode?
    promocode_id.present? && promocode.valid?
  end

  private

  def price_with_all_discounts(price = service.price)
    return promocode.discounted_value(price) if promocode?

    price
  end
end
