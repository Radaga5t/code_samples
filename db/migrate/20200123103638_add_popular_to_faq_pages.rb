class AddPopularToFaqPages < ActiveRecord::Migration[5.2]
  def change
    add_column :faq_pages, :popular, :boolean, default: false
  end
end
