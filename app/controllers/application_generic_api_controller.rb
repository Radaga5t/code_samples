# frozen_string_literal: true

# Рутовый api контроллер без плюшек авторизации и JSONAPI
class ApplicationGenericApiController < ActionController::API
  before_action :set_locale
  before_action :generate_guest_session

  private

  def set_locale
    I18n.locale = params[:locale] ||
                  http_accept_language.compatible_language_from(
                    I18n.available_locales
                  ) ||
                  I18n.default_locale
  end

  def current_user
    @current_user ||= super
    @current_user ||= warden.user(scope: :user, run_callbacks: false)
  end
end
