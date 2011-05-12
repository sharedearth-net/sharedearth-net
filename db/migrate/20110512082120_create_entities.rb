class CreateEntities < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|
      t.integer :entity_type_id
      t.integer :specific_entity_id

      t.timestamps
    end
  end

  def self.down
    drop_table :entities
  end
end
