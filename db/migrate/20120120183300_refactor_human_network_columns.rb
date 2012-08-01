# including it here as it is used in following migration
class EntityType
  PERSON_ENTITY         = 1.freeze
  ITEM_ENTITY           = 2.freeze
  SKILL_ENTITY          = 3.freeze
  VILLAGE_ENTITY        = 4.freeze
  COMMUNITY_ENTITY      = 5.freeze
  PROJECT_ENTITY        = 6.freeze
  TRUSTED_PERSON_ENTITY = 7.freeze
  MUTUAL_PERSON_ENTITY = 	8.freeze
end

class RefactorHumanNetworkColumns < ActiveRecord::Migration

  def self.add_index_with_quiet(table_name, column_names, options = {})
    quiet = options.delete(:quiet)
    add_index table_name, column_names, options
  rescue
    raise unless quiet
    puts "Failed to create index #{table_name} #{column_names.inspect} #{options.inspect}"
  end

  def self.remove_index_with_quiet(table_name, column_names, options = {})
    quiet = options.delete(:quiet)
    raise "no options allowed for remove_index, except quiet with this hack #{__FILE__}:#{__LINE__}" unless options.empty?
    remove_index table_name, column_names
  rescue
    raise unless quiet
    puts "Failed to drop index #{table_name} #{column_names.inspect}"
  end

  def self.up

    remove_column :human_networks, :entity_id
    rename_column :human_networks, :person_id, :entity_id

    add_column :human_networks, :entity_type, :string
    add_column :human_networks, :entity_master_id, :integer
    add_column :human_networks, :human_network_type, :string
    rename_column :human_networks, :trusted_person_id, :human_id
    add_column :human_networks, :human_type, :string, :default => "Person"
    add_column :human_networks, :human_entity_id, :integer
    
    HumanNetwork.reset_column_information

    HumanNetwork.update_all("entity_type='Person'")
    HumanNetwork.update_all("human_type='Person'")
    HumanNetwork.update_all("human_network_type='TrustedNetwork'",  ["entity_type_id = ?", EntityType::TRUSTED_PERSON_ENTITY])
    HumanNetwork.update_all("human_network_type='MutualNetwork'",  ["entity_type_id = ?", EntityType::MUTUAL_PERSON_ENTITY])

    HumanNetwork.all.each do |hn|
      hn.entity_master_id = Entity.where(:specific_entity_id => hn.entity_id, :specific_entity_type => hn.entity_type).first.id
      hn.human_entity_id = Entity.where(:specific_entity_id => hn.human_id, :specific_entity_type => hn.human_type).first.id
      hn.save
    end

    remove_column :human_networks, :entity_type_id

    remove_index_with_quiet :human_networks, :entity_id, :quiet => true

    add_index_with_quiet :human_networks, [ :entity_master_id ], :quiet => true
    add_index_with_quiet :human_networks, [ :human_id ], :quiet => true
    add_index_with_quiet :human_networks, [ :entity_id, :entity_type ], :quiet => true

  end

  def self.down

    add_column :human_networks, :entity_type_id, :integer

    HumanNetwork.update_all("entity_type_id=#{EntityType::TRUSTED_PERSON_ENTITY}",  ["human_network_type = ?", 'TrustedNetwork'])
    HumanNetwork.update_all("entity_type_id=#{EntityType::MUTUAL_PERSON_ENTITY}",  ["human_network_type = ?", 'MutualNetwork'])

    remove_column :human_networks, :human_entity_id
    remove_column :human_networks, :human_type
    rename_column :human_networks, :human_id, :trusted_person_id
    remove_column :human_networks, :human_network_type
    remove_column :human_networks, :entity_master_id
    remove_column :human_networks, :entity_type

    rename_column :human_networks, :entity_id, :person_id

    add_column :human_networks, :entity_id, :integer
    HumanNetwork.update_all("entity_id=trusted_person_id")

  end
end
