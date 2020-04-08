class ChangeDefaultSeoCategoryDepthLevel < ActiveRecord::Migration[5.2]
  def change
    change_column :seo_categories, :depth_level, :integer, default: 0
  end
end
