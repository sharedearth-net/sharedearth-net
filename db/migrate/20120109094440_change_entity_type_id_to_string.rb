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
