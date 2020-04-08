# frozen_string_literal: true

require 'colorscore'

module Assets
  # Ассет - изображение
  class ImageAsset < Asset
    class Uploader < AssetsImageUploader; end

    mount_uploader :file, Uploader
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

    before_update :cropping_without_file_upload

    def original
      return unless file.url

      {
        url: file.url,
        meta: meta['original'] || {}
      }
    end

    def dominant_colors
      meta['dominant_colors'] || []
    end

    def versions
      file.versions.each_with_object({}) do |(key, value), versions|
        key_string = key.to_s
        next unless meta.key?(key_string)

        versions[key_string] = {
          url: value.url, meta: meta.fetch(key_string)
        }
        if key == :tiny_thumb
          versions[key_string]['base64'] = meta.fetch('tiny_thumb_base64')
        end
      end
    end

    private

    def cropping_without_file_upload
      if !file_changed? && crop_x.present? && crop_y.present? && crop_h.present? && crop_w.present?
        file.recreate_versions!
      end
    end
  end
end
