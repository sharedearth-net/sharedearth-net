class Entity < ActiveRecord::Base
  scope :item, lambda { |entity| where("entity_type_id =? AND specific_entity_id = ?", 2, entity.id) }
end
