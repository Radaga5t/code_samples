# frozen_string_literal: true

# Дефолтный аплоадер файлов, от него необходимо наследоваться
# всем аплоадерам файлов в системе
class DefaultFileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  after :remove, :delete_empty_upstream_dirs

  storage :file

  def store_dir
    if Rails.env.test?
      Rails.root.join(
        "tmp/uploads/files/#{model.class.to_s.underscore}/#{model.id}"
      )
    else
      "uploads/files/#{model.class.to_s.underscore}/#{model.id}"
    end
  end

  def extension_whitelist
    %w[json txt jpg jpeg gif png mp4 mov pdf doc xls docx xlsx odt odc pages numbers]
  end

  private

  def delete_empty_upstream_dirs
    path = ::File.expand_path(store_dir, root)
    Dir.delete(path) # fails if path not empty dir
  rescue SystemCallError
    true # nothing, the dir is not empty
  end
end
