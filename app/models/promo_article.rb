# frozen_string_literal: true

# Модель промо-роликов/статей на главной странице
class PromoArticle < ApplicationRecord
  include HasAssets

  translates :title

  accepts_nested_attributes_for :translations, allow_destroy: true

  belongs_to :blog_article,
             class_name: 'Blog::Article',
             dependent: :destroy,
             optional: true

  image_asset :image_preview,
              validate: {
                presence: true
              }

  validates :image_preview, presence: true
end
