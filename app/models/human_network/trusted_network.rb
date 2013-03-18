class TrustedNetwork < HumanNetwork

  after_create :update_extended_network_after_create
  after_destroy :update_extended_network_after_destroy

  def update_extended_network_after_create

    # relationship getting converted from Mutual to Trusted
    if ExtendedNetwork.where( :entity_id => self.entity_id, :person_id => self.person_id ).exists?
      ExtendedNetwork.where( :entity_id => self.entity_id, :person_id => self.person_id ).each { |mn| mn.destroy }
    end

    entity_ids_to_insert = HumanNetwork.find_by_sql("select distinct(person_id) " + #select all mutual_person ids
      "from human_networks where network_type = 'TrustedNetwork' and specific_entity_type = 'Person' and entity_id in " + # person should be friend of
      "(select person_id from human_networks where specific_entity_type = 'Person' and entity_id = #{self.entity_id} and network_type = 'TrustedNetwork') " + # current person's friend
      "and person_id not in" + # but should not be
      "(select person_id from human_networks where specific_entity_type = 'Person' and entity_id = #{self.entity_id} and network_type = 'TrustedNetwork') " + # friend of current person
      "and person_id != #{self.entity_id} " + # and not current person
      "and person_id not in" + # and that person is
      "(select person_id from human_networks where specific_entity_type = 'Person' and entity_id = #{self.entity_id} and network_type = 'ExtendedNetwork') ") # not already a mutual person
    entity_ids_to_insert.each do |pi|
      ExtendedNetwork.create!( :specific_entity => self.entity, :person_id => pi["person_id"] )
      #creating reverse relation at the same time
      ExtendedNetwork.create!( :specific_entity_type => "Person", :entity_id => pi["person_id"], :person_id => self.entity_id )
    end
  end

  def update_extended_network_after_destroy

    # relationship getting converted from Trusted to Mutual
    if TrustedNetwork.where( :entity_type => 'Person', :entity_id => TrustedNetwork.where( :entity_id => self.entity_id ).collect { |tn| tn.person_id }, :person_id => self.person_id ).exists?
      ExtendedNetwork.create!( :specific_entity_type => self.specific_entity_type, :entity_id => self.entity_id, :person_id => self.person_id )
    end

    human_networks_to_delete = HumanNetwork.destroy_all("entity_type = 'Person' and entity_id = #{self.entity_id} and network_type = 'ExtendedNetwork' " +# delete all mutual friends
      "and person_id not in (" + # except
      "select distinct(person_id) " + #select all mutual_person ids
      "from human_networks where network_type = 'TrustedNetwork' and specific_entity_type = 'Person' and entity_id in " + # person should be friend of
      "(select person_id from human_networks where specific_entity_type = 'Person' and entity_id = #{self.entity_id} and network_type = 'TrustedNetwork') " + # current person's friend
      "and person_id not in " + # but should not be
      "(select person_id from human_networks where specific_entity_type = 'Person' and entity_id = #{self.entity_id} and network_type = 'TrustedNetwork') " + # friend of current person
      "and person_id != #{self.entity_id} )") # and not current person

    #also delete reverse MUTUAL relations
    human_networks_to_delete = HumanNetwork.destroy_all("person_id = #{self.entity_id} and network_type = 'ExtendedNetwork' " +# delete all mutual friends
      "and entity_type = 'Person' and entity_id not in (" + # except
      "select distinct(person_id) " + #select all mutual_person ids
      "from human_networks where network_type = 'TrustedNetwork' and specific_entity_type = 'Person' and entity_id in " + # person should be friend of
      "(select person_id from human_networks where specific_entity_type = 'Person' and entity_id = #{self.entity_id} and network_type = 'TrustedNetwork') " + # current person's friend
      "and person_id not in " + # but should not be
      "(select person_id from human_networks where specific_entity_type = 'Person' and entity_id = #{self.entity_id} and network_type = 'TrustedNetwork') " + # friend of current person
      "and person_id != #{self.entity_id} )") # and not current person

  end


end
