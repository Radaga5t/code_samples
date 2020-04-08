# frozen_string_literal: true

module Seo
  # Главная страница SEO-приложения
  class MainPage < ApplicationRecord
    include HasAssets

    image_asset :cover_image
    image_asset :og_image
  end
end
