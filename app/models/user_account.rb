# frozen_string_literal: true

# Модель счета пользователя, валюта счета - кредиты
class UserAccount < ApplicationRecord
  register_currency :crd
  monetize :amount_cents, with_model_currency: 'CRD'

  # связан с пользователем
  belongs_to :user, inverse_of: :user_account, touch: true

  # у аккаунта пользователя есть связанные купленные услуги
  has_many :user_services, dependent: :destroy

  # у аккаунта пользователя есть транзакции
  has_many :user_account_transactions

  has_many :refill_transactions,
           dependent: :destroy,
           class_name: 'AccountTransactions::RefillTransaction',
           foreign_key: :user_account_id,
           inverse_of: :user_account

  has_many :service_activation_transactions,
           dependent: :destroy,
           class_name: 'AccountTransactions::ServiceActivationTransaction',
           foreign_key: :user_account_id,
           inverse_of: :user_account

  has_many :service_refund_transactions,
           dependent: :destroy,
           class_name: 'AccountTransactions::ServiceRefundTransaction',
           foreign_key: :user_account_id,
           inverse_of: :user_account

  # проверка баланса из хеша удаленного пользователя
  before_create :set_default_amount

  ## подключаем бизнес логику работы с уведомлениями
  Notifications::Extensions::ForUserAccount.instance.connect(self)

  def account_number
    format('%016d', id * 1028).scan(/.{4}/)
  end

  # @param [Money] amount
  # @return [AccountTransactions::RefillTransaction]
  def refill(amount)
    refill_transactions.create(
      amount: amount
    )
  end

  # @param [Money] amount
  # @return [AccountTransactions::RefillTransaction]
  def refill!(amount)
    refill_transactions.create!(
      amount: amount
    )
  end

  # @return [Services::Subscriptions::UserSubscription]
  def active_subscription
    Services::Subscriptions::UserSubscription
      .active
      .find_by(user_account: self)
  end

  def active_subscription?
    active_subscription.present?
  end

  def no_active_subscription?
    active_subscription.blank?
  end

  # @param [Services::Subscriptions::SubscriptionService] subscription
  # @param [Promocode] promocode
  # @return [AccountTransactions::ServiceActivationTransaction]
  def new_subscription(subscription, promocode = nil)
    _new_subscription(subscription, promocode)
  end

  # @param [Services::Subscriptions::SubscriptionService] subscription
  # @param [Promocode] promocode
  # @return [AccountTransactions::ServiceActivationTransaction]
  def new_subscription!(subscription, promocode = nil)
    raise ActiveSubscriptionExistError if active_subscription?

    _new_subscription(subscription, promocode)
  end

  # @return [Float]
  def subscription_duration
    return nil unless active_subscription?

    (latest_subscription_active_until - Time.current) / 1.hour
  end

  def latest_subscription_active_until
    return nil unless active_subscription?

    Services::Subscriptions::UserSubscription
      .order(active_until: :desc)
      .where('active_until > ? and user_account_id = ?', Time.current, self.id)
      .select(:id, :active_until)
      .first
      .active_until
  end

  private

  def set_default_amount
    email_hash = Digest::MD5.hexdigest(user.email)
    self.amount = DeletedUserHash.find_by(
      unique_hash: email_hash
    )&.balance_amount || Money.new(0, 'CRD')
  end

  # @param [Services::Subscriptions::SubscriptionService] subscription
  # @param [Promocode] promocode
  # @return [ActiveRecord::HasOneAssociation<AccountTransactions::ServiceActivationTransaction>]
  def _new_subscription(subscription, promocode = nil)
    a = Services::Subscriptions::UserSubscription.create(
      user_account: self,
      service: subscription,
      promocode: promocode
    )

    a.service_activation_transaction
  end
end

class ActiveSubscriptionExistError < StandardError; end
