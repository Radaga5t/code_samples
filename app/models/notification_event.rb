# frozen_string_literal: true

# Модель события для уведомлений
class NotificationEvent < ApplicationRecord
  attr_readonly :type, :slug

  # привязан к элементу, который является объектом этого события
  belongs_to :subject,
             polymorphic: true,
             optional: true,
             inverse_of: :in_notification_events

  # привязан к элементу, жизненный цикл которого породил это событие
  belongs_to :target,
             polymorphic: true,
             optional: true,
             inverse_of: :fired_notification_events

  # создает множество уведомлений пользователя
  has_many :user_notifications, dependent: :destroy

  # обязательно должен иметь тип события
  validates :type, presence: true

  # обязательно должен иметь строковое описание типа события
  validates :slug, presence: true

  enum status: {
    created: 0,
    deferred: 1,
    in_progress: 2,
    processed: 3,
    failed: 4
  }

  def ready_to_process?
    created? || deferred? || failed?
  end
end
