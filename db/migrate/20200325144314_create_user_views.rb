class CreateUserViews < ActiveRecord::Migration[5.2]
  def change
    create_table :user_views do |t|
      t.references :user_view_statistic, index: true
      t.references :user
      t.inet :ip, index: true
      t.string :unique_id, index: true
      t.jsonb :hit
      t.timestamp :viewed_at, default: -> { 'CURRENT_TIMESTAMP' }
    end

    change_table :task_views do |t|
      t.inet :ip, index: true
      t.string :unique_id, index: true
    end
  end
end
