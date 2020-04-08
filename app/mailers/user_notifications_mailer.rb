# frozen_string_literal: true

# Рассыльщик писем для пользовательских уведомлений
class UserNotificationsMailer < ApplicationMailer
  prepend_view_path Rails.root.join('app', 'lib', 'notifications', 'mail_views')

  default to: -> { @to }

  helper MailsHelper

  before_action do
    globalize_fix
    @notification = UserNotifications::Email.find_by(
      id: params[:notification_id]
    )
    I18n.locale = @notification.user.locale
    @notification.in_progress!
    prepare_attributes
  end

  def notify
    mail(
      subject: interpolate_field('title')
    ) do |format|
      format.html do
        render "#{@notification.user.locale}/#{@template_name}", layout: "mailer.#{@notification.user.locale}"
      end
      format.text do
        render plain: interpolate_field('message')
      end
    end
  end

  private

  def prepare_attributes
    return if @notification.blank?

    @to = %("#{@notification.user.name}" <#{@notification.user.email}>)
    @template_name = @notification.notification_event.type.demodulize.downcase
  end

  def interpolate_field(field_name)
    @notification.interpolate_string(
      @notification.send("#{field_name}_#{@notification.user.locale}")
    )
  end

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
