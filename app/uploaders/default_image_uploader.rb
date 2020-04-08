# frozen_string_literal: true

# Дефолтный аплоадер изображений, от него необходимо наследоваться
# всем аплоадерам изображений в системе
class DefaultImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  after :remove, :delete_empty_upstream_dirs

  storage :file

  def store_dir
    if Rails.env.test?
      Rails.root.join(
        "tmp/uploads/images/#{model.class.to_s.underscore}/#{model.id}"
      )
    else
      "uploads/images/#{model.class.to_s.underscore}/#{model.id}"
    end
  end

  def extension_whitelist
    %w[jpg jpeg gif png bmp tif tiff svg]
  end

  def content_type_whitelist
    %r{image\/}
  end

  private

  def delete_empty_upstream_dirs
    path = ::File.expand_path(store_dir, root)
    Dir.delete(path) # fails if path not empty dir
  rescue SystemCallError
    true # nothing, the dir is not empty
  end
end
