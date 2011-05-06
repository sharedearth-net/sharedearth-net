class EventLog < ActiveRecord::Base
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
  
  scope :involves, lambda { |entity| where("(primary_id = ? AND primary_type = ?) OR (secondary_id = ? AND secondary_type = ?) ", entity.id, entity.class.to_s, entity.id, entity.class.to_s) }
  scope :completed_requests, lambda { where("event_type_id IN (?)", EventType.events_completed) }

  validates_presence_of :primary_id, :primary_type, :primary_short_name, :primary_full_name
  # validates_presence_of :action_object_id, :action_object_type, :action_object_type_readable
  # validates_presence_of :related_id, :related_type

  # #####
  # create methods
  # #####
  def self.create_trust_established_event_log(first_person, second_person)
    event_log = EventLog.create!(
      :primary => first_person,
      :primary_short_name => first_person.first_name,
      :primary_full_name => first_person.name,
      :action_object => nil,
      :action_object_type_readable => nil,
      :secondary => second_person,
      :secondary_short_name => second_person.first_name,
      :secondary_full_name => second_person.name,
      :related => nil,
      :event_type_id => EventType.trust_established
    )
    
    EventEntity.create!(:event_log => event_log, :entity => first_person)
    EventEntity.create!(:event_log => event_log, :entity => second_person)
    
    event_log
  end
  
  def involved_as_requester?(person)
    self.primary_id == person.id
  end
  
  def involved_as_gifter?(person)
    self.secondary_id == person.id
  end

  def involved?(person)
    self.secondary_id == person.id || self.primary_id == person.id
  end
  
    
  # One method to log all events
  # First param: first involved subject
  # Second param: second involved subject - optional
  # Third param: Item or Skill this ActivityLog is connected to - optional
  # Forth param: Type of the event that occured
  # #####
  # USE: If there is no second person nor object in event, just use nil on those places
  
  def self.create_news_event_log(first_person, second_person, object, event_type)
    if(second_person.nil?)
      second_person_first_name = nil
      second_person_name = nil
    else
      second_person_first_name = second_person.first_name
      second_person_name = second_person.name    
    end
    
    if(object.nil?)
      action_object_type_readable = nil
    else
      action_object_type_readable = object.item_type
    end
    
    event_log = EventLog.create!(
      :primary => first_person,
      :primary_short_name => first_person.first_name,
      :primary_full_name => first_person.name,
      :action_object => object,
      :action_object_type_readable => action_object_type_readable,
      :secondary => second_person,
      :secondary_short_name => second_person_first_name,
      :secondary_full_name => second_person_name,
      :related => nil,
      :event_type_id => event_type
    )
    
    if(!first_person.nil?) 
      EventEntity.create!(:event_log => event_log, :entity => first_person)
    end
    
    if(!second_person.nil?)
      EventEntity.create!(:event_log => event_log, :entity => second_person)
    end
    
    if(!object.nil?)
      EventEntity.create!(:event_log => event_log, :entity => object)
    end
    
    event_log
  end
end
