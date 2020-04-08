# frozen_string_literal: true

# Модель игнорируемого задания
class UserHiddenTask < ApplicationRecord
  belongs_to :user,
             inverse_of: :user_favorite_tasks

  belongs_to :task,
             inverse_of: :user_favorite_tasks
end
