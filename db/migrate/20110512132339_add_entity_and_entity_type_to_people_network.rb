class AddEntityAndEntityTypeToPeopleNetwork < ActiveRecord::Migration
  def self.up
    add_column :people_networks, :entity_id, :integer
    add_column :people_networks, :entity_type_id, :integer

    ActiveRecord::Base.connection.execute("UPDATE people_networks SET entity_id = trusted_person_id , entity_type_id = #{ EntityType::TRUSTED_PERSON_ENTITY }")
  end

  def self.down
    remove_column :people_networks, :entity_id
    remove_column :people_networks, :entity_type_id  
  end
end
