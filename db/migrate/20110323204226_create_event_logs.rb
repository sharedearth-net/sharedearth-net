class CreateEventLogs < ActiveRecord::Migration
  def self.up
    create_table :event_logs do |t|
      t.integer :primary_id
      t.string  :primary_type
      t.string  :primary_short_name
      t.string  :primary_full_name
      t.integer :action_object_id
      t.string  :action_object_type
      t.string  :action_object_type_readable
      t.integer :secondary_id
      t.string  :secondary_type
      t.string  :secondary_short_name
      t.string  :secondary_full_name
      t.integer :related_id
      t.string  :related_type
      t.integer :event_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :event_logs
  end
end
