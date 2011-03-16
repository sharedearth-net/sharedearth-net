class CreateActivityLogs < ActiveRecord::Migration
  def self.up
    create_table :activity_logs do |t|
      t.integer :event_code
      t.integer :primary_id
      t.string  :primary_type
      t.integer :action_object_id
      t.string  :action_object_type
      t.string  :action_object_type_readable
      t.integer :secondary_id
      t.string  :secondary_type
      t.string  :secondary_short_name
      t.string  :secondary_full_name
      t.integer :related_id
      t.string  :related_type
      t.timestamps
    end
    
    add_index(:activity_logs, :event_code)
    add_index(:activity_logs, [:primary_id, :primary_type])    
  end

  def self.down
    drop_table :activity_logs
  end
end
