# frozen_string_literal: true

# Модель уведомлений пользователя
class UserNotification < ApplicationRecord
  translates :title, :message
  globalize_accessors locales: I18n.available_locales,
                      attributes: %i[title message]

  accepts_nested_attributes_for :translations

  # привязан к пользователю, которому это уведомление отправляется
  belongs_to :user, inverse_of: :user_notifications

  # привязан к событию, которое это уведомление порождает
  belongs_to :notification_event

  # привязан к объекту события
  belongs_to :subject,
             polymorphic: true,
             optional: true,
             inverse_of: :in_user_notifications

  # через +notification_event+ связан с элементом,
  # жизненный цикл которого породил само событие
  delegate :target, to: :notification_event
  delegate :target_type, to: :notification_event
  delegate :target_id, to: :notification_event

  # не может быть инициализирован без указания конкретного типа
  validates :type, presence: true

  scope :for_user, ->(user) { where(user: user) }

  def set_title_from_i18n(key,
                          locales: I18n.available_locales,
                          default: '')
    locales.each do |locale|
      send(
        "title_#{locale}=",
        i18n_string(key, locale, default)
      )
    end
  end

  def set_message_from_i18n(key,
                            locales: I18n.available_locales,
                            default: '')
    locales.each do |locale|
      send(
        "message_#{locale}=",
        i18n_string(key, locale, default)
      )
    end
  end

  def interpolate_string(string)
    instance_eval %(%[#{string}]), __FILE__, __LINE__
  end

  def notification_type
    notification_event.type.split(/^\w+::(\w+)$/).last.downcase
  end

  private

  def i18n_string(key, locale, default)
    I18n.t(key, locale: locale,
                scope: [:notifications],
                default: default)
  end
end
