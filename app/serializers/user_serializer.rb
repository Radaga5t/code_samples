# frozen_string_literal: true

# AMS сериалайзер для пользователей
class UserSerializer < ActiveModel::Serializer
  attributes :id, :uid,
             :name, :middlename, :lastname, :sex,
             :email, :phone,
             :user_role_ids,
             :provider, :user_type,
             :interface_configuration

  has_many :user_roles
end
