# frozen_string_literal: true

# Модель Заданий
class Task < ApplicationRecord
  include HasAssets
  include Tasks::HasUniqueId
  include Tasks::HasFormData
  include Tasks::HasStatuses
  include Tasks::HasTaskResponses
  include Tasks::HasUserChats
  include Tasks::HasUserReviews
  include Tasks::HasViewStatistics
  include Tasks::HasRefund
  include Tasks::Submittable
  include Tasks::Searchable
  include Tasks::HasUserNotifications
  include Tasks::HasFavoriteAndHiddenTasks

  translates :title, :description, :private_text, :reason_text, :additional_requirements,
             touch: true,
             fallbacks_for_empty_translations: true

  globalize_accessors locales: I18n.available_locales,
                      attributes: %i[title description private_text reason_text additional_requirements]

  accepts_nested_attributes_for :translations, allow_destroy: true

  # пренадлежит пользователю
  belongs_to :user, inverse_of: :tasks, touch: true

  # имеет множество разговорных языков
  has_and_belongs_to_many :languages

  monetize :budget_cents
  monetize :commission_cents

  enum payment_method: {
    sbr: 0,
    other: 1
  }

  enum task_date_type: {
    date_from: 0,
    date_until: 1,
    date_interval: 2
  }

  file_assets :photos

  before_save :sync_user_stats, unless: -> { draft? || closed? }, if: -> { status_changed? }
  after_close :sync_user_stats
  after_close :sync_contractor_stats

  default_scope -> { order(created_at: :desc) }

  def is_first_published
    self.class.where(user_id: user_id, status: :published).size === 1
  end
end
