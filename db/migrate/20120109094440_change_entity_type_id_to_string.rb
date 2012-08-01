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

class ChangeEntityTypeIdToString < ActiveRecord::Migration
  def self.up
    add_column :entities, :specific_entity_type, :string

    Entity.update_all("specific_entity_type='Person'",  ["entity_type_id = ?", EntityType::PERSON_ENTITY])
    Entity.update_all("specific_entity_type='Item'",  ["entity_type_id = ?", EntityType::ITEM_ENTITY])
    Entity.update_all("specific_entity_type='Skill'",  ["entity_type_id = ?", EntityType::SKILL_ENTITY])
    Entity.update_all("specific_entity_type='Village'",  ["entity_type_id = ?", EntityType::VILLAGE_ENTITY])
    Entity.update_all("specific_entity_type='Community'",  ["entity_type_id = ?", EntityType::COMMUNITY_ENTITY])
    Entity.update_all("specific_entity_type='Project'",  ["entity_type_id = ?", EntityType::PROJECT_ENTITY])

    remove_column :entities, :entity_type_id

    add_index :entities, [ :specific_entity_type, :specific_entity_id]
  end

  def self.down
    add_column :entities, :entity_type_id, :integer

    Entity.update_all("entity_type_id=#{ EntityType::PERSON_ENTITY }",  ["specific_entity_type = ?", "Person"])
    Entity.update_all("entity_type_id=#{ EntityType::ITEM_ENTITY }",  ["specific_entity_type = ?", "Item"])
    Entity.update_all("entity_type_id=#{ EntityType::SKILL_ENTITY }",  ["specific_entity_type = ?", "Skill"])
    Entity.update_all("entity_type_id=#{ EntityType::VILLAGE_ENTITY }",  ["specific_entity_type = ?", "Village"])
    Entity.update_all("entity_type_id=#{ EntityType::COMMUNITY_ENTITY }",  ["specific_entity_type = ?", "Community"])
    Entity.update_all("entity_type_id=#{ EntityType::PROJECT_ENTITY }",  ["specific_entity_type = ?", "Project"])

    remove_column :entities, :specific_entity_type
  end
end
