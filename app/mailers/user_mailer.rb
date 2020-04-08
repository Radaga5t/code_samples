# frozen_string_literal: true

# Рассыльщик писем для Devise
class UserMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers

  default template_path: 'devise/mailer'
  layout 'mailer'

  before_action do
    globalize_fix
  end

  def confirmation_instructions(record, token, opts={})
    I18n.locale = record.locale
    @token = token
    devise_mail(record, :confirmation_instructions, opts)
  end

  def reset_password_instructions(record, token, opts={})
    I18n.locale = record.locale
    @token = token
    devise_mail(record, :reset_password_instructions, opts)
  end

  def unlock_instructions(record, token, opts={})
    I18n.locale = record.locale
    @token = token
    devise_mail(record, :unlock_instructions, opts)
  end

  def email_changed(record, opts={})
    I18n.locale = record.locale
    devise_mail(record, :email_changed, opts)
  end

  def password_change(record, opts={})
    I18n.locale = record.locale
    devise_mail(record, :password_change, opts)
  end

  def new_oauth_user(record, opts={})
    I18n.locale = record.locale
    devise_mail(record, :new_oauth_user, opts)
  end

  private

  def globalize_fix
    storage = RequestStore.store
    return if storage[:globalize_fallbacks].present?

    fallback_hash = HashWithIndifferentAccess.new
    { en: %i[en hu ru], hu: %i[hu en ru], ru: %i[ru hu en] }.each do |key, value|
      fallback_hash[key] = value.presence || [key]
    end
    storage[:globalize_fallbacks] = fallback_hash
  end
end
