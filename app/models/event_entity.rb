class EventEntity < ActiveRecord::Base
  belongs_to :event_log
  belongs_to :entity, :polymorphic => true # person, community, ... anyone and anything related to the event
  
  scope :involves, lambda { |entity| where("(entity_id = ? AND entity_type = ?)", entity.id, entity.class.to_s) }
end
