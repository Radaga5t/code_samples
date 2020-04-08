class AddCityGrammarToSeoCities < ActiveRecord::Migration[5.2]
  def change
    add_column :seo_cities, :city_grammar, :string
  end
end
