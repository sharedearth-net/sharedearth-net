class Item < ActiveRecord::Base
  include PaperclipWrapper

  STATUS_NORMAL  = 10.freeze
  STATUS_LOST    = 20.freeze
  STATUS_DAMAGED = 30.freeze
  
  PURPOSE_SHARE     = 10.freeze
  PURPOSE_GIFT      = 20.freeze
  PURPOSE_SHAREAGE  = 30.freeze
  PURPOSE_COMMUNAL  = 40.freeze
  
  PURPOSES = {
    PURPOSE_SHARE => 'share',
    PURPOSE_GIFT  => 'gift'
  }

  STATUSES = {
    STATUS_NORMAL     => 'normal',
    STATUS_LOST       => 'lost',
    STATUS_DAMAGED    => 'damaged'
  }
  
  STATUSES_VISIBLE_TO_OTHER_USERS = [ STATUS_NORMAL, STATUS_DAMAGED ]
  REQUESTABLE_STATUSES = [ STATUS_NORMAL ]
  
  has_many :item_requests
  belongs_to :owner, :polymorphic => true

  has_many :activity_logs, :as => :action_object
  has_many :activity_logs_as_related, :as => :related

  has_many :event_logs, :as => :action_object
  has_many :event_logs_as_related, :as => :related

  has_attachment :photo,
                 :styles => {
                   :large => "600x600>",
                   :medium => "150x150>",
                   :small => "100x100>",
                   :square => "50x50"
                  },
                 :default_url => "/images/noimage-:style.png"

  validates_inclusion_of :purpose, :in => [PURPOSE_SHARE, PURPOSE_GIFT],
                         :message => " must be in #{PURPOSES.values.join ', '}"
  validates_presence_of :purpose, :item_type, :name, :owner_id, :owner_type, :status
  validates_inclusion_of :status, :in => STATUSES.keys, 
                         :message => " must be in #{STATUSES.values.join ', '}"
  
  after_create :create_entity_for_item
  after_create :add_to_resource_network
  after_create :item_event_log
  
  validates_attachment_size :photo, :less_than => 1.megabyte
  validates_attachment_content_type :photo, :content_type => /image\//
  
  scope :without_deleted, :conditions => { :deleted_at => nil }
  scope :only_normal, :conditions => { :status => STATUS_NORMAL }
  scope :only_lost, :conditions => { :status => STATUS_LOST }
  scope :only_damaged, :conditions => { :status => STATUS_DAMAGED }
  scope :visible_to_other_users, where("status IN (#{STATUSES_VISIBLE_TO_OTHER_USERS.join(",")})")

  def is_owner?(entity)
    self.owner == entity
  end
  
  def item_event_log
    EventLog.create_news_event_log(self.owner, nil,  self , EventType.add_item, self)
  end
  
  def has_photo?
    !self.photo_file_name.nil?
  end
  
  def add_to_resource_network
    ResourceNetwork.create!(:entity_id => self.owner.id, :entity_type_id => 1, :resource_id => self.id, :resource_type_id => 2)
  end

  def self.search(search, person_id)
    if search.empty?
        nil
    else
        person = Person.find_by_id(person_id)
        items_sql = "select distinct resource_id from resource_networks where entity_id in (select entity_id from people_networks where person_id = #{person_id} and entity_type_id = 7)"     
        words = search.split(/[ ]/)
        item_type_like = words.map{|k| "upper(item_type) LIKE upper('%#{k}%') " }.join(" AND ")
        item_name_like = words.map{|k| "upper(name) LIKE upper('%#{k}%')" }.join(" AND ")
        item_desc_like = words.map{|k| "upper(description) LIKE upper('%#{k}%')" }.join(" AND ")
        sql_like = "(" + item_type_like + ") OR (" + item_name_like + ") OR (" + item_desc_like + ")"
        search_sql = "select id from items where id in (#{items_sql}) and (#{sql_like})"
        items_ids = ActiveRecord::Base.connection.execute(search_sql) 
 
        ids = items_ids.map{ |i| i["id"] }
        Item.where(:id => ids)
    end
  end
  
  def transfer_ownership_to(entity)
    self.owner = entity
    save!
  end
  
  def in_trusted_network_for_person?(person)
    self.owner.trusts?(person)
  end
  
  def create_entity_for_item
    Entity.create!(:entity_type_id => EntityType::ITEM_ENTITY, :specific_entity_id => self.id)
  end
  
  def active_request_by?(user)
    item_request = ItemRequest.find(:last, :conditions => ["requester_id =? and requester_type=? and item_id=?", user.person.id,"Person", self.id])
    item_request.nil? ? false : ItemRequest::ACTIVE_STATUSES.include?(item_request.status)    
  end
  
  def purpose?
    PURPOSES[self.purpose]
  end



  def restore
    self.deleted_at = nil
    self.deleted = false
    save!
  end

  # #######
  # Status related methods
  # #######

  def status_name
    STATUSES[status]
  end

  def normal?
    self.status == STATUS_NORMAL
  end

  def lost?
    self.status == STATUS_LOST
  end

  def damaged?
    self.status == STATUS_DAMAGED
  end
 
  def damaged!
    self.status = STATUS_DAMAGED
    save!
    EventLog.create_news_event_log(self.owner, nil,  self , EventType.item_damaged, self)
  end

  def normal!
    status = self.status
    self.status = STATUS_NORMAL
    save!
    EventLog.create_news_event_log(self.owner, nil,  self , EventType.item_repaired, self) if status == STATUS_DAMAGED
  end

  def lost!
    self.status = STATUS_LOST
    save!
  end
  
  def can_be_requested?
    REQUESTABLE_STATUSES.include? self.status
  end
  
  # #######
  # Purpose related methods
  # #######
  def share?
    self.purpose == PURPOSE_SHARE
  end
    
  def gift?
    self.purpose == PURPOSE_GIFT
  end
    
  def share!
    self.purpose = PURPOSE_SHARE
    save!
  end
  
  def gift!
    self.purpose = PURPOSE_GIFT
    save!
  end
  
  def create_new_item_event_log
    #EventLog.create_news_event_log(self.owner, nil,  self , EventType.add_item, self)
  end

  def create_new_item_activity_log
    ActivityLog.create_add_item_activity_log(self)
  end
  
  # #######
  # Metods related to item availability - true/false, if item is available
  # #######
  
  def available!
    self.available = true
    save!
  end
  
  def in_use!
    self.available = false
    save!
  end
  
  def available?
    self.available
  end
  
  def purpose_update_available?
    self.available?
  end
  
  def public_activities
     ActivityLog.item_public_activities(self).order("created_at desc").take(7)
  end   

  def delete
    set_attrs_before_deleting
    delete_new_item_activity_log
    delete_new_item_event_log
    save!
  end 

  def deleted?
    !deleted_at.nil?  or deleted
  end

  private

  def set_attrs_before_deleting
    self.deleted_at = Time.zone.now
    self.deleted = true
    self.name = 'This item has been removed'
    self.description = ''
    self.photo = nil
  end

  def delete_new_item_activity_log
    new_item_act_log = activity_logs.where(:event_type_id => EventType.add_item).first
    new_item_act_log.destroy unless new_item_act_log.nil?
  end
  
  def delete_new_item_event_log
    new_item_event_log = event_logs.where(:event_type_id => EventType.add_item).first
    new_item_event_log.destroy unless new_item_event_log.nil?
  end
end
