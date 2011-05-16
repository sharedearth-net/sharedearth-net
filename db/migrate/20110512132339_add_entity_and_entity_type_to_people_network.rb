class AddEntityAndEntityTypeToPeopleNetwork < ActiveRecord::Migration
  def self.up
    add_column :people_networks, :entity_id, :integer
    add_column :people_networks, :entity_type_id, :integer
    relationships =  PeopleNetwork.all
    relationships.each do | r |
      r.update_attributes(:entity_id => r.trusted_person_id, 
                          :entity_type_id => EntityType::TRUSTED_PERSON_ENTITY)
    end
  end

  def self.down
    remove_column :people_networks, :entity_id
    remove_column :people_networks, :entity_type_id  
  end
end
