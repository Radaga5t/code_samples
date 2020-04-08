class AddSlugToFaqPage < ActiveRecord::Migration[5.2]
  def change
    add_column :faq_pages, :slug, :string, default: nil
  end
end
