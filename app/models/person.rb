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
  has_many :activity_logs_as_secondary, :as => :secondary
  
  validates_presence_of :user_id, :name

  def belongs_to?(some_user)
    user == some_user
  end
  
  def trusts?(other_person)
    self.people_networks.involves_as_trusted_person(other_person).first
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
end
