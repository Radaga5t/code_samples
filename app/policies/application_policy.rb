# frozen_string_literal: true

# Дефолтные политики
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def new?
    true
  end

  def create?
    new?
  end

  def index?
    true
  end

  def show?
    true
  end

  def edit?
    true
  end

  def update?
    edit?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class.name == 'Class' ? record : record.class)
  end

  # Скоупы для дефолтных политик
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
