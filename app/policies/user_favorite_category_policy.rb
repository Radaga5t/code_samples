# frozen_string_literal: true

# Разрешения для категорий
class UserFavoriteCategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    true
  end

  def create?
    false
  end

  def edit?
    false
  end

  def update?
    true
  end

  def destroy?
    false
  end
end