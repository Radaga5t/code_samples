# frozen_string_literal: true

# Дефолтные политики для модели ответа на задания {TaskResponse}
class TaskResponsePolicy < ApplicationPolicy
  # @!attribute [r] record
  #   @return [User]

  def new?
    user.present?
  end

  def create?
    new?
  end

  def index?
    true
  end

  def show?
    record.status == 'published' || record.status == 'selected' || (user.present? && record.user_id == user.id)
  end

  def edit?
    return false if user.blank?

    (record.status == 'published' && record.task.user_id == user.id) ||
      (record.user_id == user.id)
  end

  def update?
    edit?
  end

  def destroy?
    update?
  end
end
