class AddTagsToFaqPages < ActiveRecord::Migration[5.2]
  def change
    add_column :faq_pages, :tags, :string, array: true
  end
end
