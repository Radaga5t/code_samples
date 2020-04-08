# frozen_string_literal: true

# Модель отклика на задания
class TaskResponse < ApplicationRecord
  include TaskResponses::HasStatuses
  include TaskResponses::Submittable
  include TaskResponses::HasRefund
  include TaskResponses::HasUserChats
  include TaskResponses::Viewable
  include TaskResponses::HasUserNotifications

  translates :description

  belongs_to :user, inverse_of: :task_responses, touch: true
  belongs_to :task, inverse_of: :task_responses, touch: true, counter_cache: :task_responses_count

  # имеет одну услугу пользователя
  has_one :user_service,
          class_name: 'Services::SingleOffers::UserTaskResponseService',
          dependent: :destroy,
          inverse_of: :task_response

  monetize :budget_cents
  monetize :commission_cents

  def is_first_published
    self.class.where(user_id: user_id, status: :published).size === 1
  end
end
