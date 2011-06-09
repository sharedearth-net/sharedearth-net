class ChangeEventIdToEventLogId < ActiveRecord::Migration
  def self.up
    rename_column :event_displays, :event_id, :event_log_id
  end

  def self.down
    rename_column :event_displays, :event_log_id, :event_id
  end
end
