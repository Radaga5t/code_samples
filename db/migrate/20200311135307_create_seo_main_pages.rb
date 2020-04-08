class CreateSeoMainPages < ActiveRecord::Migration[5.2]
  def change
    create_table :seo_main_pages do |t|
      t.string :title
      t.text   :description
      t.string :seo_title
      t.text   :seo_description

      t.text   :seo_text

      t.timestamps
    end
  end
end
