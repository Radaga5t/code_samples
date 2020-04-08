# frozen_string_literal: true

module JsonApiSerializers
  # Сериализатор для категорий
  class CategorySerializer
    include FastJsonapi::ObjectSerializer

    @not_simple_entity_cond = ->(_, params) { params[:simple].blank? || params[:simple] != true }

    set_key_transform :camel_lower
    attributes :name, :title, :slug, :parent_id, :depth_level, :personal_color

    attribute :icon do |record|
      ActionController::Base.helpers.image_url(record.icon.file.url) if record.icon.present?
    end

    attribute :ad_banner do |record|
      ActionController::Base.helpers.image_url(record.ad_banner.file.url) if record.ad_banner.present?
    end

    ## Conditional attributes

    attribute :description, if: @not_simple_entity_cond
    attribute :files_optional, if: @not_simple_entity_cond
    attribute :task_templates, if: @not_simple_entity_cond
    attribute :languages_optional, if: @not_simple_entity_cond
    attribute :documents_optional, if: @not_simple_entity_cond
    attribute :additional_requirements_optional, if: @not_simple_entity_cond
  end
end
