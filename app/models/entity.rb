class Entity < ActiveRecord::Base

  belongs_to :specific_entity, :polymorphic => true

  scope :item, lambda { |entity| where("specific_entity_type =? AND specific_entity_id = ?", "Item", entity.id) }
end
