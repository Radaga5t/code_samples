class ChangeDefaultsUserEmailNotifications < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :subscribe_to_system_messages, :boolean, default: true
    change_column :users, :subscribe_to_site_news, :boolean, default: true
  end
end
