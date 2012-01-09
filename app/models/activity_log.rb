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
  scope :item_public_activities, lambda { |entity| where("(action_object_id = ? AND action_object_type = ? and event_type_id IN (?) ) ", entity.id, entity.class.to_s, EventType.current_actions_underway_items) }
  scope :unread, where(:read => false)
  scope :email_not_sent, where("email_notification_id is null")
  scope :include_person, lambda { |entity| where("(primary_id = ? AND primary_type = 'Person') OR (secondary_id = ? AND secondary_type = 'Person')", entity.id, entity.id)}
  scope :involves_request, lambda { |entity| where("related_id = ? and related_type = ?", entity.id, "ItemRequest") }
  scope :comment_requester_events, where("event_type_id IN (?)",[64] )
  scope :comment_gifter_events, where("event_type_id IN (?)",[63] )

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
   
   def self.create_person_join_activity_log(person)
     event_code = ActivityLog.next_event_code

     # create log for owner
     ActivityLog.create!(
       :event_code => event_code,
       :primary => person,
       :action_object => nil,
       :action_object_type_readable => nil,
       :related => nil,
       :event_type_id => EventType.new_person_join
     )
   end
   
  # More general method for saving activity logs
  # First param: item_request object from which activity log will be created
  # Second param: Type of the event for gifter
  # Third param: Type of the event for the requester 
  # #####
  #THIS IS ONLY USED WHEN TWO PERSONS CONFIRMS RELATIONSHIP, SECOND PERSON IS THE ONE WHO CONFIRMS TRUST
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

    # create log for gifter, also used for person who confirmed relationship
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

  def self.create_item_request_comment_activity_log(item_request, commentier)
    if item_request.requester?(commentier)
      other_entity = item_request.gifter
      event_type = 63
    else
      other_entity = item_request.requester
      event_type = 64
    end
    event_code = ActivityLog.next_event_code

    # create log for other entity
    ActivityLog.create!(
      :event_code => event_code,
      :primary => other_entity,
      :action_object => item_request.item,
      :action_object_type_readable => item_request.item.item_type,
      :secondary => commentier,
      :secondary_short_name => commentier.first_name,
      :secondary_full_name => commentier.name,
      :related => item_request,
      :event_type_id => event_type
    )
  end

  def is_read!
  	self.read = true
    save!
  end

  def is_read?
  	self.read == true
  end

  def log_notification_email!(entity)
  	self.email_notification_id = entity.id
    save!
  end

  #Check if passed person value initiated activity log (Recent activity)
  def recent_activity_subject?(current_person)
    if current_person != self.secondary
      person = false
    else
      person = true
    end

  case self.event_type_id
    when 1
      true
    when 2
      person
    when 3
      true
    when 4
      true
    when 5
      true
    when 6
      person
    when 7
      person
    when 8
      person
    when 9
      true
    when 10
      person
    when 11
      true
    when 12
      true
    when 13
      person
    when 14
      true
    when 15
      person
    when 16
      person
    when 17
      true
       
      
    when 27
      true
    when 28
      true
    when 29
      person
    when 30
      person
    when 31
      person
    when 32
      true
    when 33
      true
    when 34
      person
    when 35
      true
    when 36
      person
    when 37
      person
    when 38
      true
    when 39
      true
    when 40
      true
    when 41
      person
    when 42
      true
    when 43
      person
    when 44
      true
    when 45
      true
    when 46
      person
    when 47
      true
    when 48
      person
    when 49
      true
    when 51
      true
    when 52
      true
    when 53
      true
    when 54
      true
    when 55
      person
    when 56
      person
    when 57
      person
    when 58
      person
    when 59
      person
    when 60
      person
		when 61
      true
    when 62
      person
    when 63
      false
    when 64
      false
    else
      true
    end

  end
end
