# frozen_string_literal: true

# Модель данных верификации телефона и дул пользователя
class UserVerification < ApplicationRecord
  include HasAssets

  CONNECTED_SOCIALS = %i[facebook linkedin google_oauth2].freeze
  RESEND_TIMEOUT = 2.minutes.freeze

  attr_accessor :phone_confirmation_code

  belongs_to :user, touch: true

  image_asset :identity_document,
              resize: [:resize_to_limit, 1920, 1920],
              versions: {
                medium: [:resize_to_limit, 640, 640],
                small: [:resize_to_limit, 200, 200]
              }

  image_asset :executor_photo,
              resize: [:resize_to_limit, 768, 768],
              versions: {
                small: [:resize_to_limit, 200, 200]
              }

  define_model_callbacks :confirm_id, only: %i[after]
  define_model_callbacks :confirm_phone, only: %i[after]

  ## подключаем бизнес логику работы с уведомлениями и начинаем прослушивать
  Notifications::Extensions::ForUserVerification.instance.connect(self).listen

  delegate :phone, to: :user
  delegate :email, to: :user

  def verified?
    id_confirmed == true
  end

  def social_account(provider)
    user.user_socials.where(provider: provider).exists?
  end

  def connected_socials
    socials = user.user_socials.select(:provider).pluck(:provider)
    Hash[UserVerification::CONNECTED_SOCIALS.map { |provider| [provider, socials.include?(provider.to_s)] }]
  end

  def email_confirmed
    user.confirmed?
  end

  def email_confirmed_at
    user.confirmed_at
  end

  def email_confirmation_sent_at
    user.last_confirmation_sent_at || user.confirmation_sent_at
  end

  def confirm_id
    return true if id_confirmed

    run_callbacks :confirm_id do
      self.id_confirmed = true
      self.id_confirmed_at = Time.current
      save
    end

    true
  end

  def new_phone_confirmation_code
    rand.to_s[2..5]
  end

  def confirm_phone_request
    confirmation_code = new_phone_confirmation_code
    self.phone_confirmation_metadata['phone_confirmation_code'] = confirmation_code
    self.phone_confirmation_metadata['created_at'] = Time.current
    self.phone_confirmation_metadata['sent_at'] = Time.current
    self.phone_confirmation_metadata['can_be_resent_at'] = Time.current + UserVerification::RESEND_TIMEOUT
    send_confirmation_sms(
      [phone.delete('+')],
      I18n.t('sendpulse.sms_confirmation', locale: user.locale, code: confirmation_code)
    )
    save
  end

  def invalidate_phone_verification
    self.phone_confirmed = false
    self.phone_confirmed_at = nil
    self.phone_confirmation_metadata = {}
    save
  end

  def confirm_phone
    return true if phone_confirmed

    run_callbacks :confirm_phone do
      self.phone_confirmed = true
      self.phone_confirmed_at = Time.current
      self.phone_confirmation_metadata = {}
      save
    end

    true
  end

  def confirm_phone_with_code(code)
    return true if phone_confirmed

    if code.blank? ||
       code.to_i != phone_confirmation_metadata['phone_confirmation_code'].to_i
      return errors.add(
        :phone_confirmation_code,
        :invalid_value,
        message: 'code is invalid'
      )
    end

    run_callbacks :confirm_phone do
      self.phone_confirmed = true
      self.phone_confirmed_at = Time.current
      self.phone_confirmation_metadata = {}
      save
    end

    true
  end

  def send_confirmation_sms(phone_number, text)
    Sendpulse::API.sms_send(
      phone_number,
      text
    )
  end
end
