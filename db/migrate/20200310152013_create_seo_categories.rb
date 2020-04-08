class CreateSeoCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :seo_categories do |t|
      t.references :category

      t.integer :parent_id
      t.integer :depth_level
      t.string  :slug
      t.string  :personal_color

      t.string  :seo_title
      t.string  :seo_description

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Seo::Category.create_translation_table! title: :string,
                                                description: :text,
                                                seo_text: :text,
                                                seo_text2: :text
      end

      dir.down do
        Seo::Category.drop_translation_table!
      end
    end

    create_table :seo_categories_categories do |t|
      t.references :category, index: true
      t.references :seo_category, index: true

      t.timestamps
    end
  end
end
