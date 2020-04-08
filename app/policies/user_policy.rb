# frozen_string_literal: true

# Дефолтные политики для модели пользователя {User}
class UserPolicy < ApplicationPolicy
  # @!attribute [r] record
  #   @return [User]

  def new?
    false
  end

  def create?
    false
  end

  def index?
    true
  end

  def show?
    true
  end

  def edit?
    user.present? && (record.id == user.id || user.administrator?)
  end

  def update?
    edit?
  end

  def destroy?
    user.present? && record.id == user.id
  end
end
