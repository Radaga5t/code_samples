# frozen_string_literal: true

# Модель статистики просмотров аккаунта пользователя, количества созданных
# и выполненных заданий
class UserViewStatistic < ApplicationRecord
  belongs_to :user

  # имеет множество записей о просмотре
  has_many :user_views, dependent: :destroy, inverse_of: :user_view_statistic

  class << self
    def calc_stats!(user_id)
      rec = where(user_id: user_id).first
      rec.calc_stats! if rec.present?
    end
  end

  def calc_stats!
    calc_stats
    save
  end

  def calc_stats
    return if user.nil? || !user.tasks.exists?

    self.user_task_created = user.tasks.where.not(status: [:draft]).size
    self.user_task_executed = user
                                .task_responses
                                .joins(:task)
                                .where('task_responses.status = ? AND tasks.status = ?',
                                       TaskResponse.statuses['selected'],
                                       Task.statuses['closed'])
                                .size
  end
end
