# frozen_string_literal: true

module JsonApiSerializers
  # сериалайзер для пользователей
  class UserSerializer
    include FastJsonapi::ObjectSerializer
    include Helpers::Cache
    include Helpers::Money

    @not_simple_entity_cond = ->(_, params) { params[:simple].blank? || params[:simple] != true }

    set_key_transform :camel_lower

    attributes :uid,
               :created_at,
               :name,
               :middlename,
               :lastname,
               :sex,
               :email,
               :phone,
               :about,
               :birthday,
               :city_name,
               :reviews_statistic,
               :is_deleted,
               :deleted_at,
               :deleted_by

    attributes_to_cache :reviews_statistic, :avatar, :is_verified_executor

    link :self, lambda { |object|
      "/api/v1.0/users/#{object.id}"
    }

    attribute :rating, &:profile_rating

    attribute :email_confirmed do |user|
      user.confirmed_at && user.confirmed_at <= Time.current
    end

    attribute :about_string do |user|
      Strings.truncate(user.about, 160) if user.about.present?
    end

    attribute :price_per_hour do |user|
      user.price_per_hour.amount.to_i if user.price_per_hour
    end

    attribute :price_per_hour_alt do |user|
      money user, attr: :price_per_hour if user.price_per_hour
    end

    attribute :is_online, &:online

    attribute :avatar do |user|
      ActionController::Base.helpers.image_url(user.avatar) if user.avatar.present?
    end

    attribute :is_verified_executor do |user|
      user.executor? && user.user_verification.verified?
    end

    ## Conditional attributes

    attribute :is_executor, if: @not_simple_entity_cond, &:executor?
    attribute :city, if: @not_simple_entity_cond do |user|
      user.city if user.city.present?
    end

    ## Conditional relationships

    has_many :languages, if: @not_simple_entity_cond
    has_many :user_favorite_categories, if: @not_simple_entity_cond
    has_one :user_verification, if: @not_simple_entity_cond
    has_one :user_view_statistic, if: @not_simple_entity_cond
    has_one :user_account, if: lambda { |user, params|
      params[:current_user] && user.id == params[:current_user].id && @not_simple_entity_cond[user, params]
    }
  end
end
