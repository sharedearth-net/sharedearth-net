class Entity < ActiveRecord::Base

  belongs_to :specific_entity, :polymorphic => true

  def type
    case entity_type_id
    when EntityType::PERSON_ENTITY
      "Person"
    when EntityType::ITEM_ENTITY
      "Item"
    when EntityType::SKILL_ENTITY
      "Skill"
    when EntityType::VILLAGE_ENTITY
      "Village"
    when EntityType::COMMUNITY_ENTITY
      "Community"
    when EntityType::PROJECT_ENTITY
      "Project"
    when EntityType::TRUSTED_PERSON_ENTITY
      raise "error"
      # don't know what to do
    when EntityType::MUTUAL_PERSON_ENTITY
      raise "error"
      # don't know what to do
    end
  end

  scope :item, lambda { |entity| where("entity_type_id =? AND specific_entity_id = ?", 2, entity.id) }
end
