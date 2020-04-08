# frozen_string_literal: true

module JsonApiSerializers
  # Сериализатор для промо-видео/ссылок на блог на главной
  class PromoArticleSerializer
    include FastJsonapi::ObjectSerializer

    set_key_transform :camel_lower
    attributes :title, :video_url, :created_at, :updated_at

    belongs_to :blog_article, serializer: JsonApiSerializers::Blog::ArticleSerializer

    attribute :image_preview do |record|
      ActionController::Base.helpers.image_url(record.image_preview.file.url) if record.image_preview.present?
    end

    attribute :url do |record|
      "/blog/articles/#{record.blog_article.slug}" if record.blog_article.present?
    end
  end
end
