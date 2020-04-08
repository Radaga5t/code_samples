# frozen_string_literal: true

module Assets
  # Ассет - файл
  class FileAsset < Asset
    class Uploader < AssetsFileUploader; end

    mount_uploader :file, Uploader

    def original
      return unless file.url

      {
        url: file.url,
        meta: meta['original'] || {}
      }
    end

    def versions
      file.versions.each_with_object({}) do |(key, value), versions|
        key_string = key.to_s
        next unless meta.key?(key_string)

        versions[key_string] = {
          url: value.url, meta: meta.fetch(key_string)
        }
      end
    end

    def extension
      file.file.extension if file.file.present?
    end
  end
end
