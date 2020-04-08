# frozen_string_literal: true

# Дефолтные политики для модели задания {Task}
class TaskPolicy < ApplicationPolicy
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

  def map_pointers?
    true
  end

  def map_pointer?
    true
  end

  def show?
    record.status == 'published' || record.status == 'contractor_selected' || record.status == 'closed' ||
      (user.present? && record.user_id == user.id)
  end

  def edit?
    user.present? && (record.user_id == user.id ||
      (record.status == 'contractor_selected' && record.selected_task_response.first.user.id == user.id))
  end

  def update?
    edit?
  end

  def destroy?
    update?
  end
end
