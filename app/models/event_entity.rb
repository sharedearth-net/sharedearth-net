class EventEntity < ActiveRecord::Base
  belongs_to :event_log
  belongs_to :entity, :polymorphic => true # person, community, ... anyone and anything related to the event
end
