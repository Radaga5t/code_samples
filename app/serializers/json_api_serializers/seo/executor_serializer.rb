# frozen_string_literal: true

module JsonApiSerializers
  module Seo
    # Сериализатор для исполнителей. Для приложения СЕО.
    class ExecutorSerializer
      include FastJsonapi::ObjectSerializer

      set_key_transform :camel_lower

      attributes :name, :lastname, :sex, :about, :birthday, :reviews_statistic,
                 :rating, :price_per_hour, :online, :avatar, :city,
                 :last_review_as_executor, :last_review_user_data,
                 :last_review_user_photo, :last_review_user_likes

      attribute :is_verified_executor do |user|
        user.executor? && user.user_verification.verified?
      end

      attribute :portfolio_images do |user|
        user.portfolios.map { |p| p&.file&.url if p.file&.url.present? }
      end
    end
  end
end
