# frozen_string_literal: true

# Модель Роль Пользователя
class UserRole < ApplicationRecord
  include HasImmutableRecords

  DEFAULT_ROLE = :user

  class << self
    # дефолтная роль из базы
    # @return [UserRole]
    def default_role
      find_by(slug: self::DEFAULT_ROLE)
    end

    # все роли для выбранного пользователя
    # @return [UserRole::ActiveRecord_Relation]
    def for_user(user)
      joins(:users).where(users: { id: user.id }).distinct
    end
  end

  # имеет множество пользователей
  has_and_belongs_to_many :users

  # имеет множество разрешений (только для этой роли)
  has_and_belongs_to_many :permissions, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  default_scope -> { order('immutable DESC, index, created_at') }
end
