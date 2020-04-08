class CreateFaqCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :faq_categories do |t|
      t.integer :parent_id
      t.integer :depth_level, default: 0

      t.string :slug
      t.integer :sort, default: 100
      t.boolean :active, default: true

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Faq::Category.create_translation_table! title: :string
      end

      dir.down do
        Faq::Category.drop_translation_table!
      end
    end
  end
end
