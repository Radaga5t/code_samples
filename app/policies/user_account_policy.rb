# frozen_string_literal: true

# Дефолтные политики для модели аккаунта пользователя {User}
class UserAccountPolicy < ApplicationPolicy
  # @!attribute [r] record
  #   @return [User]

  def new?
    false
  end

  def create?
    false
  end

  def index?
    false
  end

  def show?
    user.present? && record.user_id === user.id
  end

  def edit?
    show?
  end

  def update?
    edit?
  end

  def destroy?
    false
  end

  def refill?
    user.present? && record.user_id === user.id
  end

  # Скоупы для дефолтных политик аккаунтов
  class Scope < ApplicationPolicy::Scope
    # @return [UserAccount::ActiveRecord_Relation]
    def resolve
      scope.where(user: user)
    end
  end
end
