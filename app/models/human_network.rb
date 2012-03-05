class HumanNetwork < ActiveRecord::Base

  before_save :update_entity_ids

  belongs_to :entity, :polymorphic => true
  belongs_to :human, :class_name => "Person"
  
  set_inheritance_column "human_network_type"

  belongs_to :person, :foreign_key => :entity_id, :conditions => [ "entity_type = ", "Person" ]
  belongs_to :trusted_person, :class_name => "Person", :foreign_key => "human_id"

  scope :involves_as_trusted_person, lambda { |person| where(:human_id => person) }
  scope :involves_as_person, lambda { |person| where(:entity_id => person, :entity_type => "Person") }
  scope :involves, lambda { |person| where("( entity_id = ? AND entity_type = 'Person' ) OR human_id = ?", person.id, person.id) }

  scope :trusted_personal_network, where(:human_network_type => "TrustedNetwork")
  scope :mutual_network, where(["human_network_type = ?", "MutualNetwork"])
  scope :personal_network, where(["human_network_type = ? or human_network_type = ?", "TrustedNetwork", "MutualNetwork"])

  validates_presence_of :entity_id, :entity_type, :human_id

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
      TrustedNetwork.create!(:entity => first_person, :human => second_person)
      TrustedNetwork.create!(:entity => second_person, :human => first_person)
      first_person.reputation_rating.increase_trusted_network_count
      second_person.reputation_rating.increase_trusted_network_count
      EventLog.create_trust_established_event_log(first_person, second_person)
      ActivityLog.create_activity_log(first_person, second_person, nil, EventType.trust_established_other_party, EventType.trust_established_initiator)
    end
  end

  def update_entity_ids
    self.entity_master_id = self.entity.entity.id
    self.human_entity_id = self.human.entity.id
  end

end
