# frozen_string_literal: true

module JsonApiSerializers
  # Сериализатор для категорий
  class ClientReviewSerializer
    include FastJsonapi::ObjectSerializer

    set_key_transform :camel_lower
    attributes :name, :description, :text

    attribute :photo do |record|
      ActionController::Base.helpers.image_url(record.photo.file.url) if record.photo.present?
    end
  end
end
