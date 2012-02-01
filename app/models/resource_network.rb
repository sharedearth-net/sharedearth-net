class ResourceNetwork < ActiveRecord::Base
  self.inheritance_column = "inheritance_type"

  TYPE_GIFTER_AND_POSSESSOR = 10.freeze
  TYPE_GIFTER = 20.freeze
  TYPE_POSSESSOR = 30.freeze
  TYPES = {
    TYPE_GIFTER_AND_POSSESSOR => "Gifter and Possessor",
    TYPE_GIFTER => "Gifter",
    TYPE_POSSESSOR => "Possessor"
  }

  validates_presence_of :type

   scope :item, lambda { |entity| where("resource_type_id =? AND resource_id = ?", 2, entity.id) }
   scope :entity, lambda { |entity| where("entity_id =? AND entity_type_id = ?", entity.id, 1) }

   def set_possessor!(entity, entity_type_id)
     self.entity_id = entity.id
     self.entity_type_id = entity_type_id
     self.type = TYPE_GIFTER
     save!
   end

   def remove_possessor!
     self.entity_id = nil
     self.type = TYPE_GIFTER_AND_POSSESSOR
     save!
   end
end
