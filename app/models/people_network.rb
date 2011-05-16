class PeopleNetwork < ActiveRecord::Base
  belongs_to :person
  belongs_to :trusted_person, :class_name => "Person"

  scope :involves_as_trusted_person, lambda { |person| where(:trusted_person_id => person) }
  scope :involves_as_person, lambda { |person| where(:person_id => person) }
  scope :involves, lambda { |person| where("person_id = ? OR trusted_person_id = ?", person.id, person.id) }
  
  validates_presence_of :person_id, :trusted_person_id
  
  # def requester?(person)
  #   self.person == person
  # end
  # 
  # def trusted_person?(person)
  #   self.trusted_person == person
  # end

  def self.create_trust!(first_person, second_person)
    PeopleNetwork.create!(:person => first_person, :trusted_person => second_person,
                          :entity_id => second_person, 
                          :entity_type_id => EntityType::TRUSTED_PERSON_ENTITY)
    PeopleNetwork.create!(:person => second_person, :trusted_person => first_person, 
                          :entity_id => first_person, 
                          :entity_type_id => EntityType::TRUSTED_PERSON_ENTITY)
    first_person.reputation_rating.increase_trusted_network_count
    second_person.reputation_rating.increase_trusted_network_count
    EventLog.create_trust_established_event_log(first_person, second_person)
  end
end
