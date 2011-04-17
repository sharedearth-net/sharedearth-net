class CreateEventDisplays < ActiveRecord::Migration
  def self.up
    create_table :event_displays do |t|
      t.integer :type_id
      t.integer :person_id
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :event_displays
  end
end
