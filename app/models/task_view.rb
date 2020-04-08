# frozen_string_literal: true

# Модель просмотра задания
class TaskView < ApplicationRecord
  belongs_to :task_view_statistic,
             counter_cache: :task_view_count,
             inverse_of: :task_views

  belongs_to :user, optional: true
end
