class AddPersonalColorToFaqCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :faq_categories, :personal_color, :string, default: '#f5acac'
  end
end
