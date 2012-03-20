class ChangeHumanNetworks < ActiveRecord::Migration
  def self.up
    rename_column :human_networks, :entity_id, :specific_entity_id
    rename_column :human_networks, :human_id, :person_id
    rename_column :human_networks, :entity_master_id, :entity_id
    rename_column :human_networks, :human_network_type, :network_type
    remove_column :human_networks, :human_type
    remove_column :human_networks, :human_entity_id
  end

  def self.down
    rename_column :human_networks, :specific_entity_id, :entity_id
    rename_column :human_networks, :person_id, :human_id
    rename_column :human_networks, :entity_id, :entity_master_id
    rename_column :human_networks, :network_type, :human_network_type
    add_column :human_networks, :human_type, :string, :default => "Person"
    add_column :human_networks, :human_entity_id, :integer
  end
end
