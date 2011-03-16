class ActivityLog < ActiveRecord::Base
  belongs_to :primary, :polymorphic => true # e.g. person
  belongs_to :secondary, :polymorphic => true
  belongs_to :action_object, :polymorphic => true # e.g. item
  belongs_to :related, :polymorphic => true # e.g. item_request

  # For example:
  # You accepted Dan's request to share your bike
  # [primary] accepted [secondary]'s [related] your [action_object]
  # Note: this just illustrates what primary, secondary, related and action_object are.
  #       Technically speaking sentence is not generated like that.

  validates_presence_of :primary_id, :primary_type
  validates_presence_of :event_code
  validates_presence_of :action_object_id, :action_object_type, :action_object_type_readable
  validates_presence_of :related_id, :related_type

  # t.integer :event_code
  # t.integer :primary_id
  # t.string  :primary_type
  # t.integer :action_object_id
  # t.string  :action_object_type
  # t.string  :action_object_type_readable
  # t.integer :secondary_id
  # t.string  :secondary_type
  # t.string  :secondary_short_name
  # t.string  :secondary_full_name
  # t.integer :related_id
  # t.string  :related_type


end
