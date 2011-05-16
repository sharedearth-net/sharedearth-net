class Person < ActiveRecord::Base
  belongs_to :user
  has_many :items, :as => :owner
  has_many :item_requests, :as => :requester
  has_many :item_gifts, :as => :gifter, :class_name => "ItemRequest"
  has_many :people_network_requests
  has_many :received_people_network_requests, :class_name => "PeopleNetworkRequest", :foreign_key => "trusted_person_id"
  has_many :people_networks
  has_many :received_people_networks, :class_name => "PeopleNetwork", :foreign_key => "trusted_person_id"

  has_many :activity_logs, :as => :primary
  has_many :activity_logs_as_secondary, :as => :secondary, :class_name => "ActivityLog"

  has_many :event_logs, :as => :primary
  has_many :event_logs_as_secondary, :as => :secondary, :class_name => "EventLog"

  has_many :event_entities, :as => :entity
  has_many :related_event_logs, :through => :event_entities, :source => :event_log

  has_many :feedbacks
  has_one :reputation_rating

  validates_presence_of :user_id, :name
  
  #after_create :create_entity_for_person

  def belongs_to?(some_user)
    user == some_user
  end
  
  def trusts?(other_person)
    self.people_networks.involves_as_trusted_person(other_person).first
  end
  
  def create_entity_for_person
    Entity.create!(:entity_type_id => EntityType::PERSON_ENTITY, :specific_entity_id => self.id)
  end
  
  def trusted_network_size
    self.people_networks.count
  end
  
  def extended_network_size
    relationship = self.people_networks(:trusted_person_id)
    friends = Person.find(:all, :conditions => ["id IN (?)", relationship])
    if friends.count == 1
      friends.people_networks.count
    else
      size = friends.each { |person| person.people_networks.count }.sum
    end
  end

  #FIND CURRENT USER AND SHOWN USER MUTUAL FRIENDS COUNT
  def trusted_network_count(other_person)
    if self.id == other_person.id
       return self.people_networks.involves(self).count
    else
      trusted_network = 0
      self.people_networks.involves(self).each do | relationship | 
         if(self.id != relationship.person_id)
            trustee = Person.find(relationship.person_id)
         else
           trustee = Person.find(relationship.trusted_person_id)
         end
         unless trustee.people_networks.involves(other_person).empty? 
           trusted_network += 1
         end
      end
      
      #DON'T INCLUDE ME AS MUTUAL FRIEND IF I TRUST THIS PERSON
      if self.trusts?(other_person)
         trusted_network -= 1
      end
    end
    
    trusted_network
  end
  
  def trusts_me_count
    self.people_networks.involves(self).count
  end
  
  def all_item_requests
    ItemRequest.involves(self)
  end

  def active_item_requests
    ItemRequest.involves(self).active.order("created_at DESC")
  end

  def unanswered_requests(requester = nil)
    if requester
      ItemRequest.unanswered.involves(self).involves(requester)
    else
      ItemRequest.unanswered.involves(self)
    end
  end
  
  def avatar(avatar_size = nil)
    self.user.avatar(avatar_size)
  end

  def first_name
    name.split.first
  end

  def news_feed
    # Updated SQL to get all events relating to anyone in a user's trusted
    # network or to themselves
   
		ee = Arel::Table.new(EventEntity.table_name.to_sym)
    pn = Arel::Table.new(PeopleNetwork.table_name.to_sym)

    pn_network = pn.project(pn[:trusted_person_id], Arel.sql("4 as trusted_relationship_value")).where(pn[:person_id].eq(self.id))

    query = ee.project(Arel.sql("#{ee.name}.event_log_id as event_log_id"), Arel.sql("SUM(trusted_relationship_value) as total_relationship_value"))
    query = query.join(Arel.sql("LEFT JOIN (#{pn_network.to_sql}) AS network ON #{ee.name}.entity_id = network.trusted_person_id AND #{ee.name}.entity_type = 'Person'"))
    query = query.group(ee[:event_log_id], ee[:created_at]).order("#{ee.name}.created_at DESC").take(25)
    query = query.where(Arel.sql("trusted_person_id IS NOT NULL or (#{ee.name}.entity_type = 'Person' and #{ee.name}.entity_id = #{self.id})"))

    event_log_ids = EventEntity.find_by_sql(query.to_sql)

		# CASHE PREVIOUSLY SHOWN NEWS FEED IF NOT ALREADY CASHED
		event_log_ids = event_log_ids.reverse
	
		event_log_ids.each do |e|
		  conditions = { :type_id =>  EventDisplay::DASHBOARD_FEED, 
                   :person_id => self.id,
                   :event_id => e.event_log_id }
      EventDisplay.find(:first, :conditions => conditions) || EventDisplay.create(conditions) 
		end
  end
  
  #SHOW NEWS FEED THAT ARE STORED IN CASHE, BUT NOT SHOWN AT SAME TIME AS CURRENT NEWS FEED
  def news_feed_cashe(event_log_ids)
    news_event_logs = event_log_ids.map{|e| e.event_log_id}
    event_displays = EventDisplay.find(:all, :conditions => ["type_id=? and person_id=? and event_id not in (?)", 
    		                                     EventDisplay::DASHBOARD_FEED, self.id, news_event_logs], :order => 'event_id DESC').take(25)
    news_cashe_event_logs = event_displays.map{|e| e.event_id}
    EventLog.find(:all, :conditions => ["id IN (?)", news_cashe_event_logs], :order => 'created_at DESC') 
  end
  
  def gift_act_actions
    ActivityLog.gift_actions(self).size
  end
  
  def people_helped
    ActivityLog.find(:all, :select => 'DISTINCT secondary_id', 
                     :conditions => ["primary_id =? and primary_type=? and secondary_type=? and event_type_id IN (?)", 
                                      self.id, "Person", "Person", EventType.completed_request_ids]).size
  end
  
  def gift_act_rating
    rating = (self.people_helped - 1 + self.gift_act_actions.to_f/20)
    update_gift_act_rating(rating)
    rating
  end
  
  def update_gift_act_rating(rating)
    gift_act = PersonGiftActRating.find_or_create_by_person_id(:person_id => self.id)
    rating < 0 ? rating = 0 : rating
    gift_act.gift_act_rating = rating
    gift_act.save!
  end

  ###########
  # Trust related methods
  ###########
  
  def request_trusted_relationship(person_requesting)
    self.received_people_network_requests.create(:person => person_requesting)
  end
  
  def requested_trusted_relationship?(person_requesting)
    self.received_people_network_requests.where(:person_id => person_requesting).count > 0
  end

  def requested_trusted_relationship(person_requesting)
    self.received_people_network_requests.where(:person_id => person_requesting).first
  end
  
  ###########
  # Latest activity on personal page methods
  ###########
  
  def public_events
    EventLog.involves(self).completed_requests.order("#{EventLog.table_name}.created_at DESC").take(7)
  end
  
  def  public_activities(current_user)
    if current_user.person.id != self.id
      #SHOW EVENTS INVOLVING CURRENT USER AND PERSON WHOOSE PROFILE IS BEEING VIEWED
      activites = ActivityLog.find(:all, 
                         :conditions => ["(primary_id = ? AND primary_type = ? AND secondary_id = ? AND secondary_type = ? and event_type_id IN (?)) ", 
                         current_user.person.id, current_user.person.class.to_s, self.id, self.class.to_s,  EventType.current_actions_underway], :order => 'created_at DESC').take(7)
    else
      activites = ActivityLog.find(:all, 
                         :conditions => ["(primary_id = ? AND primary_type = ? and event_type_id IN (?)) ", 
                         current_user.person.id, current_user.person.class.to_s,  EventType.current_actions_underway], :order => 'created_at DESC').take(7)
    end
  end
  
end
