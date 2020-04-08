# frozen_string_literal: true

# Дефолтные политики для ролей пользователя {UserRole}
class UserRolePolicy < ApplicationPolicy
  # @!attribute [r] record
  #   @return [UserRole]

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
    scope.where(id: record.id).exists?
  end

  def edit?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  # Скоупы для дефолтных политик ролей пользователя
  class Scope < ApplicationPolicy::Scope
    # @return [UserRole::ActiveRecord_Relation]
    def resolve
      scope.for_user(user)
    end
  end
end