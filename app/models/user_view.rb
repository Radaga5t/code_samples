# frozen_string_literal: true

# Модель просмотра пользователя
class UserView < ApplicationRecord
  belongs_to :user_view_statistic,
             counter_cache: :user_view_count,
             inverse_of: :user_views

  # тот кто просмотрел, если залогинен
  belongs_to :user, optional: true
end
