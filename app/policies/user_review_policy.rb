# frozen_string_literal: true

# Разрешения для отзывов о пользователе
class UserReviewPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    false
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