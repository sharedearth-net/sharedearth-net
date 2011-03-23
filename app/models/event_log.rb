class EventLog < ActiveRecord::Base
  # t.integer :event_code - code connecting multiple ActivityLogs made for same event (e.g. one for requester, one for gifter)
  # t.integer :primary_id - primary entity (e.g. person) for whom this ActivityLog is made
  # t.string  :primary_type
  # t.string  :primary_short_name
  # t.string  :primary_full_name
  # t.integer :action_object_id - Item or Skill this ActivityLog is connected to
  # t.string  :action_object_type
  # t.string  :action_object_type_readable - Item.item_type (e.g. "bike"), used to generate messages without loading item
  # t.integer :secondary_id - [optional] secondary entity that's on the other side of ActivityLog
  # t.string  :secondary_type
  # t.string  :secondary_short_name
  # t.string  :secondary_full_name
  # t.integer :related_id - actual object that caused this ActivityLog (e.g. ItemRequest that changed its status; Item that got added to the system; ...)
  # t.string  :related_type
  # t.integer :event_type_id

  belongs_to :primary, :polymorphic => true # e.g. person
  belongs_to :secondary, :polymorphic => true
  belongs_to :action_object, :polymorphic => true # e.g. item
  belongs_to :related, :polymorphic => true # e.g. item_request
  belongs_to :event_type
  
  has_many :event_entities

  validates_presence_of :primary_id, :primary_type, :primary_short_name, :primary_full_name
  validates_presence_of :action_object_id, :action_object_type, :action_object_type_readable
  validates_presence_of :related_id, :related_type
end
