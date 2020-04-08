# frozen_string_literal: true

# Разрешения для категорий
class CategoryPolicy < ApplicationPolicy
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
    false
  end

  def destroy?
    false
  end
end