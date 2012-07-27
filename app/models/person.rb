class Person < ActiveRecord::Base

  acts_as_entity

  has_human_network :human_networks
  has_human_network :trusted_network, :class_name => "TrustedNetwork"
  has_human_network :extended_network, :class_name => "ExtendedNetwork"
  has_human_network :facebook_friend, :class_name => "FacebookFriend"
  has_human_network :member, :class_name => "Member"

  has_many :users
  has_many :items, :as => :owner
  has_many :item_requests, :as => :requester
  has_many :item_gifts, :as => :gifter, :class_name => "ItemRequest"
  has_many :network_requests
  has_many :received_network_requests,
           :class_name => "NetworkRequest",
           :foreign_key => "trusted_person_id"
  #has_many :human_networks
  has_many :received_human_networks,
           :class_name => "HumanNetwork",
           :foreign_key => "person_id"

  has_many :activity_logs, :as => :primary
  has_many :activity_logs_as_secondary, :as => :secondary, :class_name => "ActivityLog"

  has_many :event_logs, :as => :primary
  has_many :event_logs_as_secondary, :as => :secondary, :class_name => "EventLog"

  has_many :event_entities, :as => :entity
  has_many :related_event_logs, :through => :event_entities, :source => :event_log

  has_many :feedbacks
  has_many :invitations
  has_one :reputation_rating

  validates :name, :presence => true, :length => { :maximum => 20 }
  validates :email, :confirmation => true
  validates_length_of :location, :maximum => 42
  validates_length_of :description, :maximum => 400
	validates :email, :presence => true, :email => true

  after_create :create_entity_for_person
  after_create :create_staring_reputation_rating!

  before_update do |p|
    if p.email_changed?
      p.new_email = p.email
      p.email = p.email_was
    end
  end
  after_save :send_email_changing_confirmation, :if => :new_email_changed?

  #default_scope where(:authorised_account => true) if INVITATION_SYS_ON # Turning this on would couse problems
  scope :authorized, where(:authorised_account => true)
  scope :with_smart_notifications, where(:smart_notifications => true)
  scope :no_email_sent, where("email_notification_count = 0")
  scope :low_volume_email_sent, where("email_notification_count IN (1,2) AND last_notification_email < ?", Time.now - 78.hours)
  scope :high_volume_email_sent, where("email_notification_count IN (3,4) AND last_notification_email < ?", Time.now - 168.hours)
  scope :notification_candidate, where("(email_notification_count = 0) OR ((email_notification_count in (?)) AND last_notification_email < ?) OR ((email_notification_count in (?)) AND last_notification_email < ?) AND authorised_account = ?", [1,2], Time.now - 78.hours, [3,4], Time.now - 168.hours, true)
  scope :exclude_users, lambda { |entity| where("id not in (?)", entity)}
  scope :include_users, lambda { |entity| where("id in (?)", entity)}

  def facebook_user
    users.where(:provider => :facebook).first
  end

  def create_staring_reputation_rating!
    create_reputation_rating(:gift_actions  => 0,:distinct_people => 0,
                             :total_actions => 0, :positive_feedback => 0,
                             :negative_feedback => 0, :neutral_feedback => 0,
                             :requests_received => 0, :requests_answered => 0,
                             :trusted_network_count => 0,  :activity_level => 0)
  end

	def recent_activity_logs(min_count = 10)
		logs = activity_logs.where(:read => false).order("#{ActivityLog.table_name}.created_at DESC")
		if logs.count < min_count
			logs = activity_logs.order("#{ActivityLog.table_name}.created_at DESC").limit(min_count)
		end
		logs
	end

  def send_email_changing_confirmation
    UserMailer.email_change_cofirmation(self).deliver!
  end

  def email_change_confirmation_code
    Digest::SHA2.hexdigest("#{email}--#{new_email}")
  end

  def verify_email_change!(code)
    if code == email_change_confirmation_code
      Person.update_all({:email => self.new_email, :new_email => ""}, :id => self.id)
      true
    else
      false
    end
  end

	def trusted_network_activity
    my_people_id = self.human_networks.trusted_personal_network.collect { |n| n.person_id }
    my_people_id << id

    EventDisplay.select('DISTINCT event_log_id').
                 where(:person_id => my_people_id).
                 order('event_log_id DESC').
                 includes(:event_log)
  end

  def network_activity
    my_people_id = self.human_networks.collect { |n| n.person_id }
    my_people_id << id

    EventDisplay.select('DISTINCT event_log_id').
                 where(:person_id => my_people_id).
                 order('event_log_id DESC').
                 includes(:event_log)
  end

  def belongs_to?(some_user)
    some_user.person == self
  end

  def trusts?(other_person)
    self.human_networks.trusted_personal_network.involves_as_trusted_person(other_person).first
  end

  def authorised?
    self.authorised_account
  end

  def authorise!
    create_person_join_activity_log if !self.authorised_account # should get called only once
    self.authorised_account = true
    save!
  end

  def has_email?
  	self.email?
  end

  def accept_tc!
    self.accepted_tc = true
    self.tc_version  = TC_VERSION
    save!
  end

  def accepted_tc?
    self.accepted_tc and self.tc_version == TC_VERSION
  end

  def accept_tr!
    self.accepted_tr = true
    save!
  end

  def accepted_tr?
    self.accepted_tr
  end

  def accept_pp!
    self.accepted_pp = true
    self.pp_version  = PP_VERSION
    save!
  end

  def accepted_pp?
    self.accepted_pp and self.pp_version == PP_VERSION
  end

  def has_reviewed_profile?
  	self.has_reviewed_profile == true
  end

  def reviewed_profile!
    self.has_reviewed_profile == true
    save!
  end

  def create_entity_for_person
    create_entity
  end

  def trusted_network_size
    self.human_networks.trusted_personal_network.count
  end

  def personal_network_size
    self.human_networks.collect(&:person_id).uniq.count
  end

  def self.search(search)
		search.empty? ? '' : authorized.where("UPPER(name) LIKE UPPER(?)", "%#{search}%")
  end

  def searchable_core_of_friends
    ids = self.human_networks.trusted_personal_network.map { |n| n.person_id }.uniq
    ids.push( self.id)
    ids = ids.map! { |k| "#{k}" }.join(",")
  end

  def personal_network_friends
		self.human_networks.map { |n| n.trusted_person }.uniq
  end

  def trusted_friends
    self.human_networks.trusted_personal_network.uniq.map { |n| n.trusted_person }.uniq
  end
  
  def facebook_friends
    self.human_networks.facebook_friends.map { |n| n.trusted_person }.uniq
  end

  def self.with_items_more_than(items_count)
    people = Person.all.collect { |p| p if p.items.without_deleted.count >= items_count.to_i }.delete_if {|p| p.nil?}
  end

  def personal_network_items_count(type = nil)
		items_count = 0
    if type.nil?
      self.personal_network_friends.map{ |f| items_count += f.items.without_deleted.without_hidden.count }
    else
      self.personal_network_friends.map{ |f| items_count += f.items.without_deleted.without_hidden.with_type(type).count }
    end
    items_count
  end

  def personal_network_items(type = nil)
    items = []
    if type.nil?
      self.personal_network_friends.map{ |f| f.items.without_deleted.without_hidden.map{|i|items.push(i)}}
    else
      self.personal_network_friends.map{ |f| f.items.without_deleted.without_hidden.with_type(type).map{|i|items.push(i)}}
    end
    items
  end

  def trusted_friends_items_count(type = nil)
		items_count = 0
    if type.nil?
      self.trusted_friends.map{ |f| items_count += f.items.without_deleted.without_hidden.count }
    else
      self.trusted_friends.map{ |f| items_count += f.items.without_deleted.without_hidden.with_type(type).count }
    end
    items_count
  end

  def trusted_friends_items(type = nil)
    items = []
    if type.nil?
      self.trusted_friends.map{ |f| f.items.without_deleted.without_hidden.map{|i|items.push(i)}}
    else
      self.trusted_friends.map{ |f| f.items.without_deleted.without_hidden.with_type(type).map{|i|items.push(i)}}
    end
    items
  end

  def mutural_friends(other_person)
    mutural_friends = []
    self.human_networks.trusted_personal_network.each do |n|
      mutural_friends.push(n.trusted_person) if n.trusted_person.trusts?(other_person)
    end
    mutural_friends
  end

  def extended_network_size
    people_ids = self.human_networks.trusted_personal_network.map{|i| i["person_id"]}
    friends = Person.find(:all, :conditions => ["id IN (?)", people_ids])
    size = 0
    friends.each { |person| size += person.human_networks.trusted_personal_network.count }
    size
  end

  def mutural_friends_count(other_person)
    mutural_friends = 0
    self.human_networks.trusted_personal_network.each do |pn|
      mutural_friends+=1 if pn.trusted_person.trusts?(other_person)
    end
    mutural_friends
  end

  def trusts_me_count
    self.human_networks.trusted_personal_network.involves(self).count
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
    self.users.first.try(:avatar, avatar_size)
  end

  def first_name
    name.split.first
  end
  
  def news_feed
    recent_events = EventEntity.recent_events_for self
  
    weighted_events = {}
    recent_events.each do |event|
      weightage =  HumanNetwork.weightage(event.network_type) + EventType.weightage(event.event_type_id)
      weighted_events[event.event_log_id] ||= 0
      weighted_events[event.event_log_id] += weightage
    end
    
    sorted_events = weighted_events.sort_by { |k,v| v } 
    
    top_events = sorted_events.reverse[0..9]
    top_events.each do |e|
      conditions = { :type_id =>  EventDisplay::DASHBOARD_FEED,
                      :person_id => self.id,
                      :event_log_id => e[0] }
      EventDisplay.find(:first, :conditions => conditions) || EventDisplay.create(conditions)
    end
  end

  # Will remove this once story is approve
  # def news_feed
  #     # Updated SQL to get all events relating to anyone in a user's trusted
  #     # network or to themselves
  #     self_id = self.id
  #     ee = Arel::Table.new(EventEntity.table_name.to_sym)
  #     pn = Arel::Table.new(HumanNetwork.table_name.to_sym)
  # 
  #     pn_network = pn.project(pn[:person_id], Arel.sql("4 as trusted_relationship_value")).where(pn[:entity_id].eq(self_id)).where(pn[:entity_type].eq("Person"))
  # 
  #     query = ee.project(Arel.sql("#{ee.name}.event_log_id as event_log_id"), Arel.sql("SUM(trusted_relationship_value) as total_relationship_value"))
  #     query = query.join(Arel.sql("LEFT JOIN (#{pn_network.to_sql}) AS network ON #{ee.name}.entity_id = network.person_id AND #{ee.name}.entity_type = 'Person' AND user_only = 'false'"))
  #     query = query.group(ee[:event_log_id], ee[:created_at]).order("#{ee.name}.created_at DESC").take(25)
  #     query = query.where(Arel.sql("person_id IS NOT NULL or (#{ee.name}.entity_type = 'Person' and #{ee.name}.entity_id = #{self_id})"))
  # 
  #     event_log_ids = EventEntity.find_by_sql(query.to_sql)
  # 
  #     # CASHE PREVIOUSLY SHOWN NEWS FEED IF NOT ALREADY CASHED
  #     event_log_ids = event_log_ids.reverse
  # 
  #     event_log_ids.each do |e|
  #       conditions = { :type_id =>  EventDisplay::DASHBOARD_FEED,
  #                    :person_id => self_id,
  #                    :event_log_id => e.event_log_id }
  #       EventDisplay.find(:first, :conditions => conditions) || EventDisplay.create(conditions)
  #     end
  #   end

  #SHOW NEWS FEED THAT ARE STORED IN CASHE, BUT NOT SHOWN AT SAME TIME AS CURRENT NEWS FEED
  def news_feed_cashe(event_log_ids)
    news_event_logs = event_log_ids.map{|e| e.event_log_id}
    event_displays = EventDisplay.find(:all, :conditions => ["type_id=? and person_id=? and event_log_id not in (?)",
    		                                     EventDisplay::DASHBOARD_FEED, self.id, news_event_logs], :order => 'event_log_id DESC').take(25)
    news_cashe_event_logs = event_displays.map{|e| e.event_log_id}
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
    unless requested_trusted_relationship?(person_requesting)
      received_network_requests.create(:person => person_requesting)
      ActivityLog.create_activity_log(self, person_requesting, nil, EventType.trust_request, EventType.trust_request_other_party)
    end
  end

  def requested_trusted_relationship?(person_requesting)
    self.received_network_requests.where(:person_id => person_requesting).count > 0
  end

  def requested_trusted_relationship(person_requesting)
    self.received_network_requests.where(:person_id => person_requesting).first
  end

  ###########
  # Latest activity methods for personal page
  ###########

  def public_events
    EventLog.involves(self).completed_requests.order("#{EventLog.table_name}.created_at DESC").take(7)
  end

  def  public_activities(current_user)
    if !current_user.person.same_as_person?(self)
      activites = ActivityLog.activities_involving(self, current_user.person).order("created_at desc").limit(7)
    else
      activites = ActivityLog.public_activities(current_user.person).order("created_at desc").limit(7)
    end
  end

  def same_as_person?(person)
    self.id == person.id
  end

  def create_person_join_activity_log
    ActivityLog.create_person_join_activity_log(self)
  end

  #Number of vilages
  def vilages?
    0
  end

  def communities?
    0
  end

  def never_requested?
    ItemRequest.find_by_requester_id(self.id).nil?
  end

  def decrease_invitations!
    self.invitations_count -= 1
    save!
  end

  def invitations_count?
    self.invitations_count
  end

  def reset_notification_count!
    self.email_notification_count = 0
    save!
  end

  def email_notifications_count?
    self.email_notification_count
  end

  def increase_email_notification_count!
     self.email_notification_count += 1
  	 save!
  end

  def log_email_notification_time!
    self.last_notification_email = Time.now
    save!
  end

  def has_location?
    !(self.location.nil? || self.location.empty?)
  end

end
