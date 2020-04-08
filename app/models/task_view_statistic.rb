# frozen_string_literal: true

# Модель статистики просмотра задания
class TaskViewStatistic < ApplicationRecord
  belongs_to :task, inverse_of: :task_view_statistic

  # имеет множество записей о просмотре
  has_many :task_views, dependent: :destroy, inverse_of: :task_view_statistic
end
