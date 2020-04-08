# frozen_string_literal: true

module JsonApiSerializers
  # сериалайзер для баланса пользователя
  class UserVerificationSerializer
    include FastJsonapi::ObjectSerializer

    set_key_transform :camel_lower

    attributes :id_confirmed,
               :id_confirmed_at,
               :phone_confirmed,
               :phone_confirmed_at,
               :email_confirmed,
               :email_confirmed_at,
               :email_confirmation_sent_at,
               :phone_confirmation_code,
               :connected_socials

    attribute :phone, if: lambda { |record, params|
      params && params[:current_user] && params[:current_user].id == record.user.id
    }

    attribute :email, if: lambda { |record, params|
      params && params[:current_user] && params[:current_user].id == record.user.id
    }

    attribute :identity_document_present do |record|
      record.identity_document.present? && record.identity_document.file.present?
    end

    attribute :executor_photo_present do |record|
      record.executor_photo.present? && record.executor_photo.file.present?
    end

    attribute :executor_photo do |record|
      record&.executor_photo&.file&.small&.url
    end

    attribute :identity_document_present_at, if: lambda { |record, params|
      params && params[:current_user] && params[:current_user].id == record.user.id
    } do | record |
      record.identity_document.present? && record.identity_document.created_at
    end

    attribute :phone_confirmation_metadata, if: lambda { |record, params|
      params && params[:current_user] && params[:current_user].id == record.user.id
    } do | record |
      record.phone_confirmation_metadata.except('phone_confirmation_code')
    end

    belongs_to :user
  end
end
