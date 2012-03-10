# including it here as it is used in following migration
class EntityType < ActiveRecord::Base
  PERSON_ENTITY         = 1.freeze
  ITEM_ENTITY           = 2.freeze
  SKILL_ENTITY          = 3.freeze
  VILLAGE_ENTITY        = 4.freeze
  COMMUNITY_ENTITY      = 5.freeze
  PROJECT_ENTITY        = 6.freeze
  TRUSTED_PERSON_ENTITY = 7.freeze
  MUTUAL_PERSON_ENTITY = 	8.freeze
end

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
