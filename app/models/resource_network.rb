class ResourceNetwork < ActiveRecord::Base
   scope :item, lambda { |entity| where("resource_type_id =? AND resource_id = ?", 2, entity.id) }
end
