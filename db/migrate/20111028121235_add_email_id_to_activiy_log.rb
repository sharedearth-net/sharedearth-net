class AddEmailIdToActiviyLog < ActiveRecord::Migration
  def self.up
    add_column :activity_logs, :email_notification_id, :integer
  end

  def self.down
    remove_column :activity_logs, :email_notification_id
  end
end
