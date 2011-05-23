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
  
  #Action object and related object is not obligatory when two persons are establishing trust
  validates_presence_of :primary_id, :primary_type
  validates_presence_of :event_code
  #validates_presence_of :action_object_id, :action_object_type, :action_object_type_readable
  #validates_presence_of :related_id, :related_type
  
  scope :gift_actions, lambda { |entity| where("(primary_id = ? and event_type_id IN (?) ) ", entity.id, EventType.completed_request_ids) }
  scope :involves, lambda { |entity| where("(primary_id = ? AND primary_type = ?) OR (secondary_id = ? AND secondary_type = ?) ", entity.id, entity.class.to_s, entity.id, entity.class.to_s) }
  scope :completed_requests, lambda { |entity| where("event_type_id IN (?)", EventType.completed_request_ids) }
  scope :personal_actions, lambda { |entity| where("event_type_id IN (?)", EventType.personal_actions) }
  scope :activities_involving, lambda { |p1,p2| where("(primary_id = ? AND primary_type = ? AND secondary_id = ? AND secondary_type = ? and event_type_id IN (?)) ", 
                                                      p1.id, p1.class.to_s, p2.id, p2.class.to_s, EventType.current_actions_underway) }
  scope :public_activities, lambda { |entity| where("(primary_id = ? AND primary_type = ? and event_type_id IN (?) ) ", entity.id, entity.class.to_s, EventType.current_actions_underway) }

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
  
  # One method to log all activity
  # First param: item_request object from which activity log will be created
  # Second param: Type of the event for gifter
  # Third param: Type of the event for the requester 
  # #####
  
  def self.create_item_request_activity_log(item_request, event_type_gifter, event_type_requester)
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
      :event_type_id => event_type_gifter
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
      :event_type_id => event_type_requester
    )
  end

  def self.create_add_item_activity_log(item)
     event_code = ActivityLog.next_event_code

     # create log for owner
     ActivityLog.create!(
       :event_code => event_code,
       :primary => item.owner,
       :action_object => item,
       :action_object_type_readable => item.item_type,
       :related => item,
       :event_type_id => EventType.add_item
     )
   end
   
  # More general method for saving activity logs
  # First param: item_request object from which activity log will be created
  # Second param: Type of the event for gifter
  # Third param: Type of the event for the requester 
  # #####
  
  def self.create_activity_log(first_person, second_person, object, event_type_requester, event_type_gifter)
    event_code = ActivityLog.next_event_code
    if(second_person.nil?)
      second_person_first_name = nil
      second_person_name = nil
    else
      second_person_first_name = second_person.first_name
      second_person_name = second_person.name    
    end
    
    if(first_person.nil?)
      first_person_first_name = nil
      first_person_name = nil
    else
      first_person_first_name = first_person.first_name
      first_person_name = first_person.name    
    end
    
    if(object.nil?)
      action_object_type_readable = nil
    else
      action_object_type_readable = object.item_type
    end

    # create log for gifter
    ActivityLog.create!(
      :event_code => event_code,
      :primary => first_person,
      :action_object => object,
      :action_object_type_readable => action_object_type_readable,
      :secondary => second_person,
      :secondary_short_name => second_person.first_name,
      :secondary_full_name => second_person.name,
      :related => nil,
      :event_type_id => event_type_gifter
    )

    # create log for requester
    ActivityLog.create!(
      :event_code => event_code,
      :primary => second_person,
      :action_object => object,
      :action_object_type_readable => action_object_type_readable,
      :secondary => first_person,
      :secondary_short_name => first_person.first_name,
      :secondary_full_name => first_person.name,
      :related => nil,
      :event_type_id => event_type_requester
    )
  end


end
