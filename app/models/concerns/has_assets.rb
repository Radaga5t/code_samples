# frozen_string_literal: true

##
# Этот module включает все методы работы с ассетами
# Для бизнес логики используется carrierwave
# Для валидации https://github.com/musaffa/file_validators
module HasAssets
  extend ActiveSupport::Concern

  class_methods do
    ##
    # Прикрепляет множество ассетов к модели, ассеты будут доступны по вызову
    # метода с названием указанным в параметре +asset_name+
    # @param asset_name [Symbol]
    # @param resize [Array(Symbol, Number, Number), nil]
    #   ex: [:resize_to_limit or :resize_to_fill, 640, 640]
    # @param versions [{Symbol => Array(Symbol, Number, Number)}, nil]
    # @param validate [{Symbol => {Symbol => Any}}, nil]
    # @return [void]
    def image_assets(asset_name,
                     resize: nil, versions: nil, validate: nil)
      image_asset(
        asset_name,
        resize: resize,
        versions: versions,
        validate: validate,
        multiple: true
      )
    end

    ##
    # Прикрепляет ассет к модели, ассет будет доступен по вызову метода с
    # названием указанным в параметре +asset_name+
    # @param asset_name [Symbol]
    # @param resize [Array(Symbol, Number, Number), nil]
    #   ex: [:resize_to_limit or :resize_to_fill, 640, 640]
    # @param versions [{Symbol => Array(Symbol, Number, Number)}, nil]
    # @param validate [{Symbol => {Symbol => Any}}, nil]
    # @param multiple [boolean, nil]
    # @return [void]
    def image_asset(asset_name,
                    resize: nil, versions: nil, validate: nil, multiple: false)
      class_name = name

      if multiple
        asset_class = "#{class_name}::" + "#{asset_name.to_s.singularize}_asset".classify
        uploader_class = "#{class_name}::" + "#{asset_name.to_s.singularize}_uploader".classify
      else
        asset_class = "#{class_name}::" + "#{asset_name}_asset".classify
        uploader_class = "#{class_name}::" + "#{asset_name}_uploader".classify
      end

      main_resize = build_main_resize resize
      versions_resize = build_versions versions
      validations = build_validations validate

      instance_eval <<~RUBY, __FILE__, __LINE__ + 1
        class #{asset_class} < Assets::ImageAsset
          class #{uploader_class} < Assets::ImageAsset::Uploader
            #{main_resize}
            #{versions_resize}
          end
          mount_uploader :file, #{uploader_class}
          #{validations}
        end

        if #{multiple}
          has_many :#{asset_name},
                   as: :host,
                   class_name: "#{asset_class}",
                   dependent: :destroy
        else
          has_one :#{asset_name},
                  as: :host,
                  class_name: "#{asset_class}",
                  dependent: :destroy

          delegate :file, to: :#{asset_name}, prefix: true
        end

        accepts_nested_attributes_for :#{asset_name}
      RUBY
    end

    def file_assets(asset_name,
                    validate: nil)
      file_asset(
        asset_name,
        validate: validate,
        multiple: true
      )
    end

    def file_asset(asset_name,
                   validate: nil, multiple: false)
      class_name = name

      if multiple
        asset_class = "#{class_name}::" + "#{asset_name.to_s.singularize}_asset".classify
        uploader_class = "#{class_name}::" + "#{asset_name.to_s.singularize}_uploader".classify
      else
        asset_class = "#{class_name}::" + "#{asset_name}_asset".classify
        uploader_class = "#{class_name}::" + "#{asset_name}_uploader".classify
      end

      validations = build_validations validate

      instance_eval <<~RUBY, __FILE__, __LINE__ + 1
        class #{asset_class} < Assets::FileAsset
          class #{uploader_class} < Assets::FileAsset::Uploader; end
          mount_uploader :file, #{uploader_class}
          #{validations}
        end

        if #{multiple}
          has_many :#{asset_name},
                   as: :host,
                   class_name: "#{asset_class}",
                   dependent: :destroy
        else
          has_one :#{asset_name},
                   as: :host,
                   class_name: "#{asset_class}",
                   dependent: :destroy
        end

        accepts_nested_attributes_for :#{asset_name}
      RUBY
    end

    private

    def build_main_resize(resize)
      return '' unless resize&.is_a? Array

      <<~RUBY
        process :#{resize[0]} => [#{resize[1]},
                #{resize[2]}],
                if: :resize_original?
      RUBY
    end

    def build_versions(versions)
      return '' unless versions&.is_a? Hash

      versions.inject('') do |current_versions, (key, val)|
        current_versions + <<-RUBY
        version :#{key} do process #{val[0]}: [#{val[1]}, #{val[2]}] end
        RUBY
      end
    end

    def build_validations(validate)
      return '' unless validate&.is_a? Hash

      "validates :file, #{validate}"
    end
  end
end
