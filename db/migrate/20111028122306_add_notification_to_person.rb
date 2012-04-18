class AddNotificationToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :email_notification_count, :integer, :default => 0
		add_column :people, :last_notification_email, :datetime
  end

  def self.down
    remove_column :people, :email_notification_count
    remove_column :people, :last_notification_email
  end
end
