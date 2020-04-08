# frozen_string_literal: true

# Модель мета данных социальных сетей пользователя
class UserSocial < ApplicationRecord
  belongs_to :user

  after_create :set_user_photo
  validates :uid, :provider, presence: true

  def self.oauth_hash_to_attrs(auth_hash)
    {
      provider: auth_hash[:provider],
      uid: auth_hash[:uid],
      email: auth_hash[:info][:email],
      name: auth_hash[:info][:name],
      first_name: auth_hash[:info][:first_name],
      last_name: auth_hash[:info][:last_name],
      image: auth_hash[:info][:image]
    }
  end

  private

  def set_user_photo
    if user.photo.nil?
      user.photo = user.build_photo
      user.photo.remote_file_url = image
      user.photo.save
    end
  end
end
