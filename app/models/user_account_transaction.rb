# frozen_string_literal: true

# Модель транзакций
# от нее необходимо наследоваться для реализации конкретного типа транзакции
# Имплементации транзакций находятся в модуле +AccountTransactions+,
# использовать экземпляры модели +UserAccountTransaction+ напрямую нельзя
class UserAccountTransaction < ApplicationRecord
  monetize :amount_cents,
           allow_nil: false,
           numericality: {
             greater_than: 0
           }

  # не может быть инициализирован без указания конкретного типа транзакции
  validates :type, presence: true

  class << self
    def process
      pending.each(&:process)
    end

    def reject
      pending.each(&:reject)
    end

    def authorize
      pending.each(&:authorize)
    end
  end

  def pending?; end

  def process; end

  def reject; end

  def authorize; end

  def transaction_type
    case type
    when 'AccountTransactions::RefillTransaction'
      'refill-external'
    when 'AccountTransactions::ServiceRefundTransaction'
      'refill-system'
    else 'debit'
    end
  end
end
