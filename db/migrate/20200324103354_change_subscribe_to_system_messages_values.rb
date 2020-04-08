class ChangeSubscribeToSystemMessagesValues < ActiveRecord::Migration[5.2]
  def up
    User.all.each do |u|
      u.subscribe_to_system_messages = true
      u.save
    end
  end
end
