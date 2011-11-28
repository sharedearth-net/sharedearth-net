class AddSmartNotificationToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :smart_notifications, :boolean, :default => true
  end

  def self.down
    remove_column :people, :smart_notifications
  end
end
