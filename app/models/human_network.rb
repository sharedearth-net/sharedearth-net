class HumanNetwork < ActiveRecord::Base

  #before_save :update_entity_ids

  belongs_to :entity, :polymorphic => true
  belongs_to :person, :class_name => "Person"

  self.inheritance_column = "network_type"

  belongs_to :trusted_person, :class_name => "Person", :foreign_key => "person_id"

  scope :involves_as_trusted_person, lambda { |person| where(:person_id => person) }
  scope :involves_as_person, lambda { |person| where(:entity_id => person, :entity_type => "Person") }
  scope :involves, lambda { |person| where("( entity_id = ? AND entity_type = 'Person' ) OR person_id = ?", person.id, person.id) }

  scope :facebook_friends, where(:network_type => "FacebookFriend")
  scope :trusted_personal_network, where(:network_type => "TrustedNetwork")
  scope :extended_network, where(["network_type = ?", "ExtendedNetwork"])
  scope :person_items_in_villages,where(:network_type => "Village")
  
  scope :person_items_in_specific_village  , lambda { |village_id| where(:network_type => "Village", :specific_entity_id=>village_id)} 
  
  scope :person_items_in_groups,where(:network_type => "Groups")
  
  scope :village_members, lambda { |village| where("entity_id = ? AND entity_type = ? AND network_type = ?", village.id, "Village", "Member")}
  scope :village_admins, lambda { |village| where("entity_id = ? AND entity_type = ? AND network_type = ?", village.id, "Village", "GroupAdmin")}
  scope :part_of_village, lambda { |person| where("person_id = ? AND entity_type =? AND (network_type = ? OR network_type = ?)", person.id, "Village", "GroupAdmin", "Member")}
  scope :entity_types, lambda { |entity_types| where("entity_type IN (?)", entity_types) }
  scope :member, lambda { |member| where(:person_id => member.id)}
  scope :entity_network, lambda { |entity_type| where(:network_type => entity_type) }
  scope :specific_entity_network, lambda { |entity| where(:entity_type => entity.class.name, :entity_id => entity.id) }
  
  validates_presence_of :entity_id, :entity_type, :person_id
  
  
  NETWORK_WEIGHTAGE = {
    'TrustedNetwork' => 3,
    'FacebookFriend'  => 2,
    'ExtendedNetwork' => 1,
    'GroupAdmin' => 2,
    'Member' => 2
  }

  # def requester?(person)
  #   self.person == person
  # end
  #
  # def trusted_person?(person)
  #   self.trusted_person == person
  # end

  def self.create_trust!(first_person, second_person)
    # this check is to avoid duplicates
    unless first_person.trusted_network.exists?(second_person.id) || second_person.trusted_network.exists?(first_person.id)
      # 2 calls given below should be always happen in conjunction
      # for mutual network updation to be successful
      TrustedNetwork.create!(:entity => first_person, :person_id => second_person.id)
      TrustedNetwork.create!(:entity => second_person, :person_id => first_person.id)
      first_person.reputation_rating.increase_trusted_network_count
      second_person.reputation_rating.increase_trusted_network_count
      EventLog.create_trust_established_event_log(first_person, second_person)
      ActivityLog.create_activity_log(first_person, second_person, nil, EventType.trust_established_other_party, EventType.trust_established_initiator)
    end
  end
  
  def self.create_facebook_friends!(first_person, second_person)
    unless first_person.facebook_friend.where(:person_id => second_person.id).exists?
      FacebookFriend.create!(:entity => first_person, :person_id =>  second_person.id)
      FacebookFriend.create!(:entity => second_person, :person_id =>  first_person.id)
    end
  end

#Check self.entity.entity.id?
  def update_entity_ids
    self.entity_id = self.entity.entity.id
  end

  def self.weightage network_type
    NETWORK_WEIGHTAGE[network_type].present? ? NETWORK_WEIGHTAGE[network_type] : 0
  end
end
