# frozen_string_literal: true

# Модель Пользователь содержит всю бизнес логику работы с пользователем
class User < ApplicationRecord
  include HasImmutableRecords
  include HasAssets
  include Users::HasDeviseAuth
  include Users::HasUserRoles
  include Users::HasUserAccount
  include Users::HasUserSocials
  include Users::HasUserRating
  include Users::HasUserVerification
  include Users::HasUserType
  include Users::HasTasksAndTaskResponses
  include Users::HasUserChats
  include Users::HasFavoriteCategories
  include Users::HasUserNotifications
  include Users::HasViewStatistics
  include Users::HasFavoriteAndHiddenTasks
  include Users::HasDestroyLogic
  include Users::Geocoded
  include Users::HasSeoProperties
  include DeviseTokenAuth::Concerns::User

  translates :about, :price, touch: true

  # имеет множество разговорных языков
  has_and_belongs_to_many :languages,
                          after_add: :touch_updated_at,
                          after_remove: :touch_updated_at

  before_create :set_default_locale

  def locale
    interface_configuration.with_indifferent_access[:locale]&.to_sym ||
      I18n.default_locale
  end

  # имеет связанную страну
  belongs_to :country, optional: true

  # проверять на наличие полей
  validates :name, presence: true

  enum sex: %i[male female]

  monetize :price_per_hour_cents,
           allow_nil: true,
           numericality: {
             greater_than: 0
           }

  image_asset :photo,
              validate: {
                file_size: { less_than: 5.megabytes }
              },
              resize: [:resize_to_limit, 640, 640],
              versions: {
                large: [:resize_to_fill, 320, 320],
                small: [:resize_to_fill, 120, 120]
              }

  image_assets :portfolios,
               validate: {
                 file_size: { less_than: 5.megabytes }
               },
               resize: [:resize_to_limit, 1200, 1024],
               versions: {
                 large: [:resize_to_fill, 320, 256],
                 medium: [:resize_to_fill, 160, 128],
                 small: [:resize_to_fill, 80, 64]
               }

  default_scope -> { order('users.created_at DESC').includes(:user_roles) }

  def self.fast_find(id)
    unscoped.where(id: id).select(:id).first
  end

  def short_fullname
    return name if lastname.blank?

    "#{name} #{lastname[0].capitalize}."
  end

  def fullname
    [lastname, name].join(' ')
  end

  def avatar
    photo.present? && photo.file.present? ? photo.file.small.url : nil
  end

  def email_confirmed
    confirmed?
  end

  def responded_to_task?
    task_responses.exists?
  end

  def task_executed?
    task_responses.where(status: :selected).exists?
  end

  def review_as_executor_exists?
    reviews.exists?
  end

  def transactions_exists?
    user_account.refill_transactions.where(status: :processed).exists?
  end

  def token_validation_response
    JsonApiSerializers::UserForAuthSerializer.new(self).as_json
  end

  def auth_response
    token_validation_response
  end

  def hidden_profile
    hidden_until && hidden_until > Time.current
  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end

  def cache_version
    updated_at.utc.to_s(:usec)
  end

  def set_online
    update_columns(
      last_active_at: Time.current,
      online: true,
      cable_connections_count: 1
    )
  end

  def set_offline
    update_columns(
      online: false,
      cable_connections_count: 0
    )
  end

  def action_cable_connected(uuid)
    update_columns(
      last_active_at: Time.current,
      online: true,
      cable_connections_count: cable_connections_count + 1
    )

    NotificationsChannel.delay.notify_all_user_status(id)
  end

  def action_cable_disconnected(uuid)
    update_columns(
      last_active_at: Time.current,
      online: cable_connections_count > 1,
      cable_connections_count: cable_connections_count < 1 ? 0 : cable_connections_count - 1
    )

    NotificationsChannel.delay.notify_all_user_status(id)
  end

  def was_active_now
    update_columns(
      last_active_at: Time.current,
      online: true
    )
  end

  private

  def touch_updated_at(_)
    self.touch if persisted?
  end

  def set_default_locale
    self.interface_configuration = {locale: I18n.locale}.merge(interface_configuration || {})
  end
end
