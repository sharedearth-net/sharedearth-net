class ActivityLog < ActiveRecord::Base
  # t.integer :event_code - code connecting multiple ActivityLogs made for same event (e.g. one for requester, one for gifter)
  # t.integer :primary_id - primary entity (e.g. person) for whom this ActivityLog is made
  # t.string  :primary_type
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

  # For example:
  # You accepted Dan's request to share your bike
  # [primary] accepted [secondary]'s [related] your [action_object]
  # Note: this just illustrates what primary, secondary, related and action_object are.
  #       Technically speaking sentence is not generated like that.

  validates_presence_of :primary_id, :primary_type
  validates_presence_of :event_code
  validates_presence_of :action_object_id, :action_object_type, :action_object_type_readable
  validates_presence_of :related_id, :related_type

  def self.next_event_code
    current_max = ActivityLog.maximum(:event_code)
    1 + (current_max ? current_max : 0)
  end

  # #####
  # create methods
  # #####
  def self.create_new_item_request_activity_log(item_request)
    event_code = ActivityLog.next_event_code

    # create log for gifter
    ActivityLog.create!(
      :event_code => event_code,
      :primary => item_request.gifter,
      :action_object => item_request.item,
      :action_object_type_readable => item_request.item.item_type,
      :secondary => item_request.requester,
      :secondary_short_name => item_request.requester.first_name,
      :secondary_full_name => item_request.requester.name,
      :related => item_request,
      :event_type_id => EventType.new_item_request_gifter
    )

    # create log for requester
    ActivityLog.create!(
      :event_code => event_code,
      :primary => item_request.requester,
      :action_object => item_request.item,
      :action_object_type_readable => item_request.item.item_type,
      :secondary => item_request.gifter,
      :secondary_short_name => item_request.gifter.first_name,
      :secondary_full_name => item_request.gifter.name,
      :related => item_request,
      :event_type_id => EventType.new_item_request_requester
    )
  end

end
