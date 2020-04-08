class CreateUserFavoriteTask < ActiveRecord::Migration[5.2]
  def change
    create_table :user_favorite_tasks do |t|
      t.references :user, index: true
      t.references :task, index: true
    end

    create_table :user_hidden_tasks do |t|
      t.references :user, index: true
      t.references :task, index: true
    end
  end
end
