# frozen_string_literal: true

# Модель задания в избранном у пользователя
class UserFavoriteTask < ApplicationRecord
  belongs_to :user,
             inverse_of: :user_hidden_tasks

  belongs_to :task,
             inverse_of: :user_hidden_tasks
end
