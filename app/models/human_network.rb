
class HumanNetwork < ActiveRecord::Base

  #before_save :update_entity_ids

  belongs_to :entity
  belongs_to :specific_entity, :polymorphic => true
  belongs_to :person, :class_name => "Person"
  

  self.inheritance_column = "network_type"

  belongs_to :trusted_person, :class_name => "Person", :foreign_key => "person_id"

  scope :involves_as_trusted_person, lambda { |person| where(:person_id => person) }
  scope :involves_as_person, lambda { |person| where(:entity_id => person, :specific_entity_type => "Person") }
  scope :involves, lambda { |person| where("( entity_id = ? AND specific_entity_type = 'Person' ) OR person_id = ?", person.id, person.id) }

  scope :facebook_friends, where(:network_type => "FacebookFriend")
  scope :trusted_personal_network, where(:network_type => "TrustedNetwork")
  scope :extended_network, where(["network_type = ?", "ExtendedNetwork"])
  scope :person_items_in_villages,where(:network_type => "Village")
  
  scope :person_items_in_specific_village  , lambda { |village_id| where(:network_type => "Village", :specific_entity_id=>village_id)} 
  
  scope :person_items_in_groups,where(:network_type => "Groups")
  
  scope :gift_contributors, lambda { |gift| where("entity_id = ? AND specific_entity_type = ? AND network_type = ?", gift.id, "Gift", "Member")}
  scope :gift_creator, lambda { |gift| where("entity_id = ? AND specific_entity_type = ? AND network_type = ?", gift.id, "Gift", "GroupAdmin")}
  scope :gift_recipient, lambda { |gift| where("entity_id = ? AND specific_entity_type = ? AND network_type = ?", gift.id, "Gift", "Recipient")}
  scope :village_members, lambda { |village| where("entity_id = ? AND specific_entity_type = ? AND network_type = ?", village.id, "Village", "Member")}
  scope :village_admins, lambda { |village| where("entity_id = ? AND specific_entity_type = ? AND network_type = ?", village.id, "Village", "GroupAdmin")}
  scope :part_of_village, lambda { |person| where("person_id = ? AND specific_entity_type =? AND (network_type = ? OR network_type = ?)", person.id, "Village", "GroupAdmin", "Member")}
  scope :part_of_gift, lambda { |person| where("person_id = ? AND specific_entity_type =? AND (network_type = ? OR network_type = ?)", person.id, "Gift", "GroupAdmin", "Member")}
  scope :entity_types, lambda { |entity_types| where("specific_entity_type IN (?)", entity_types) }

  scope :member, lambda { |member| where(:person_id => member.id)}
  scope :entity_network, lambda { |entity_type| where(:network_type => entity_type) }
  scope :specific_entity_network, lambda { |entity| where(:specific_entity_type => entity.class.name, :entity_id => entity.id) }

  scope :trusted_network_personID_count, lambda { |person| where("entity_id = ? AND person_id = ? ", person.entities_network.uniq)}

  #for counts on community


  scope :specific_entity_id_trusted_network, lambda { |entity| where(:specific_entity_type => entity.class.name, :specific_entity_id => entity.id, :network_type=>'TrustedNetwork') } 
  
  scope :specific_entity_id_network, lambda { |entity| where(:specific_entity_type => entity.class.name, :specific_entity_id => entity.id) } 
  scope :entities_network, lambda { |ids| where("entity_id IN(#{ids})") }  
  scope :person_entities,  lambda { |person| where(:person_id => person.id).uniq }
  
  scope :member_village, lambda { |member| where(:person_id => member.id, :specific_entity_type => 'Village').uniq}
 
  scope :person_trusted_network, lambda { |person| where(:person_id => person.id, :specific_entity_type => 'Person', :network_type=>'TrustedNetwork').uniq}
  
  
  validates_presence_of :specific_entity_type, :specific_entity_id, :person_id
  
  
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


#-------------
  def self.trusted_network_person_ids_count(person, village)
    person_ids = (specific_entity_id_trusted_network(person).map(&:person_id)-[nil]).join(",")
    entity_id  = entities_network(village.id).map(&:entity_id).uniq.first

    where("person_id IN (?) AND entity_id = ?", person_ids, entity_id).map(&:person_id).count
  end

  def self.people_from_community_count(person, village)

    entities_list = involves_as_trusted_person(person).map(&:entity_id)
    entities_list = entities_list - [nil]
    entities_list = entities_list.join(",")

    person_id_list_1 = entities_network(entities_list).map(&:person_id) - Array(person.id) 
    person_id_list_2 = specific_entity_network(person).map(&:person_id)
    person_id_list = person_id_list_1 + person_id_list_2 - [nil]

    person_id_list = person_id_list.uniq        
    entity_id  = entities_network(village.id).map(&:entity_id).uniq.first

    where("person_id IN (?) AND entity_id = ?", person_id_list, entity_id).count

  end

#---------------  

  def self.create_trust!(first_person, second_person)
    # this check is to avoid duplicates
    unless first_person.trusted_network.exists?(second_person.id) || second_person.trusted_network.exists?(first_person.id)
      # 2 calls given below should be always happen in conjunction
      # for mutual network updation to be successful
      TrustedNetwork.create!(:specific_entity => first_person, :person_id => second_person.id)
      TrustedNetwork.create!(:specific_entity => second_person, :person_id => first_person.id)
      first_person.reputation_rating.increase_trusted_network_count
      second_person.reputation_rating.increase_trusted_network_count
      EventLog.create_trust_established_event_log(first_person, second_person)
      ActivityLog.create_activity_log(first_person, second_person, nil, EventType.trust_established_other_party, EventType.trust_established_initiator)
    end
  end
  
  def self.create_facebook_friends!(first_person, second_person)
    debugger
    unless first_person.facebook_friend.where(:person_id => second_person.id).exists?
      FacebookFriend.create!(:specific_entity => first_person, :entity => first_person.entity, :person_id =>  second_person.id)
      FacebookFriend.create!(:specific_entity => second_person, :entity => second_person.entity, :person_id =>  first_person.id)
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
