class AddReadToActivityLog < ActiveRecord::Migration
  def self.up
    add_column :activity_logs, :read, :boolean, :default => false
  end

  def self.down
    remove_column :activity_logs, :read
  end
end
