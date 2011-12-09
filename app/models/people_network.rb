class PeopleNetwork < ActiveRecord::Base
  belongs_to :person
  belongs_to :trusted_person, :class_name => "Person"

  scope :involves_as_trusted_person, lambda { |person| where(:trusted_person_id => person) }
  scope :involves_as_person, lambda { |person| where(:person_id => person) }
  scope :involves, lambda { |person| where("person_id = ? OR trusted_person_id = ?", person.id, person.id) }

  scope :trusted_personal_network, where(:entity_type_id => EntityType::TRUSTED_PERSON_ENTITY)
  scope :personal_network, where(["entity_type_id = ? or entity_type_id = ?", EntityType::TRUSTED_PERSON_ENTITY, EntityType::MUTUAL_PERSON_ENTITY])

  validates_presence_of :person_id, :trusted_person_id

  after_create :update_mutual_network_after_create
  after_destroy :update_mutual_network_after_destroy

  # def requester?(person)
  #   self.person == person
  # end
  # 
  # def trusted_person?(person)
  #   self.trusted_person == person
  # end

  def self.create_trust!(first_person, second_person)
		# 2 calls given below should be always happen in conjunction
		# for update_mutual_network_after_create
    PeopleNetwork.create!(:person => first_person, :trusted_person => second_person,
                          :entity_id => second_person.id, 
                          :entity_type_id => EntityType::TRUSTED_PERSON_ENTITY)
    PeopleNetwork.create!(:person => second_person, :trusted_person => first_person, 
                          :entity_id => first_person.id, 
                          :entity_type_id => EntityType::TRUSTED_PERSON_ENTITY)
    first_person.reputation_rating.increase_trusted_network_count
    second_person.reputation_rating.increase_trusted_network_count
    EventLog.create_trust_established_event_log(first_person, second_person)
    ActivityLog.create_activity_log(first_person, second_person, nil, EventType.trust_established_other_party, EventType.trust_established_initiator)
  end

  def update_mutual_network_after_create
		if self.entity_type_id == EntityType::TRUSTED_PERSON_ENTITY
			person_ids_to_insert = PeopleNetwork.find_by_sql("select distinct(trusted_person_id) " + #select all mutual_person ids
				"from people_networks where person_id in " + # person should be friend of
				"(select trusted_person_id from people_networks where person_id = #{self.person_id} and entity_type_id = #{EntityType::TRUSTED_PERSON_ENTITY}) " + # current person's friend
				"and trusted_person_id not in" + # but should not be
				"(select trusted_person_id from people_networks where person_id = #{self.person_id} and entity_type_id = #{EntityType::TRUSTED_PERSON_ENTITY}) " + # friend of current person
				"and trusted_person_id != #{self.person_id} " + # and not current person
				"and trusted_person_id not in" + # and that person is
				"(select trusted_person_id from people_networks where person_id = #{self.person_id} and entity_type_id = #{EntityType::MUTUAL_PERSON_ENTITY}) ") # not already a mutual person
			person_ids_to_insert.each do |pi|
				PeopleNetwork.create!( :person_id => self.person_id, :trusted_person_id => pi["trusted_person_id"], :entity_id => pi["trusted_person_id"], :entity_type_id => EntityType::MUTUAL_PERSON_ENTITY )
				#creating reverse relation at the same time
				PeopleNetwork.create!( :person_id => pi["trusted_person_id"], :trusted_person_id => self.person_id, :entity_id => pi["trusted_person_id"], :entity_type_id => EntityType::MUTUAL_PERSON_ENTITY )
			end
		end
  end

  def update_mutual_network_after_destroy
		if self.entity_type_id == EntityType::TRUSTED_PERSON_ENTITY

			people_networks_to_delete = PeopleNetwork.destroy_all("person_id = #{self.person_id} and entity_type_id = #{EntityType::MUTUAL_PERSON_ENTITY} " +# delete all mutual friends
				"and trusted_person_id not in (" + # except
				"select distinct(trusted_person_id) " + #select all mutual_person ids
				"from people_networks where person_id in " + # person should be friend of
				"(select trusted_person_id from people_networks where person_id = #{self.person_id} and entity_type_id = #{EntityType::TRUSTED_PERSON_ENTITY}) " + # current person's friend
				"and trusted_person_id not in " + # but should not be
				"(select trusted_person_id from people_networks where person_id = #{self.person_id} and entity_type_id = #{EntityType::TRUSTED_PERSON_ENTITY}) " + # friend of current person
				"and trusted_person_id != #{self.person_id} )") # and not current person

			#also delete reverse MUTUAL relations
			people_networks_to_delete = PeopleNetwork.destroy_all("trusted_person_id = #{self.person_id} and entity_type_id = #{EntityType::MUTUAL_PERSON_ENTITY} " +# delete all mutual friends
				"and person_id not in (" + # except
				"select distinct(trusted_person_id) " + #select all mutual_person ids
				"from people_networks where person_id in " + # person should be friend of
				"(select trusted_person_id from people_networks where person_id = #{self.person_id} and entity_type_id = #{EntityType::TRUSTED_PERSON_ENTITY}) " + # current person's friend
				"and trusted_person_id not in " + # but should not be
				"(select trusted_person_id from people_networks where person_id = #{self.person_id} and entity_type_id = #{EntityType::TRUSTED_PERSON_ENTITY}) " + # friend of current person
				"and trusted_person_id != #{self.person_id} )") # and not current person

		end
  end

end
