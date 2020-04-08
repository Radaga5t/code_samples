# frozen_string_literal: true

# Модуль админки
module Admin
  # Рутовый контроллер для админки
  class AdminController < ActionController::Base
    include Pundit

    # @!attribute current_user
    #   @return [User]

    # редиректим на главную, если пользователь не администратор
    before_action :user_can_access

    private

    def user_can_access
      if current_user &&
         !current_user.administrative_privileges?
        redirect_to '/'
      end
    end
  end
end
