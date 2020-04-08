class CreateFaqPages < ActiveRecord::Migration[5.2]
  def change
    create_table :faq_pages do |t|
      t.references :category

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Faq::Page.create_translation_table! title: :string,
                                            content: :text
      end

      dir.down do
        Faq::Page.drop_translation_table!
      end
    end
  end
end
