class CreateEventEntities < ActiveRecord::Migration
  def self.up
    create_table :event_entities do |t|
      t.integer :event_log_id
      t.integer :entity_id
      t.string  :entity_type
      t.timestamps
    end

    add_index(:event_entities, :event_log_id)
    add_index(:event_entities, [:entity_id, :entity_type])    
  end

  def self.down
    drop_table :event_entities
  end
end
