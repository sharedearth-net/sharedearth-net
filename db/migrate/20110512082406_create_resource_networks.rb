class CreateResourceNetworks < ActiveRecord::Migration
  def self.up
    create_table :resource_networks do |t|
      t.integer :entity_id
      t.integer :entity_type_id
      t.integer :resource_id
      t.integer :resource_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :resource_networks
  end
end
