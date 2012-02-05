class TrustedNetwork < HumanNetwork

  after_create :update_mutual_network_after_create
  after_destroy :update_mutual_network_after_destroy

  def update_mutual_network_after_create
    entity_ids_to_insert = HumanNetwork.find_by_sql("select distinct(human_id) " + #select all mutual_person ids
      "from human_networks where entity_type = 'Person' and entity_id in " + # person should be friend of
      "(select human_id from human_networks where entity_type = 'Person' and entity_id = #{self.entity_id} and human_network_type = 'TrustedNetwork') " + # current person's friend
      "and human_id not in" + # but should not be
      "(select human_id from human_networks where entity_type = 'Person' and entity_id = #{self.entity_id} and human_network_type = 'TrustedNetwork') " + # friend of current person
      "and human_id != #{self.entity_id} " + # and not current person
      "and human_id not in" + # and that person is
      "(select human_id from human_networks where entity_type = 'Person' and entity_id = #{self.entity_id} and human_network_type = 'MutualNetwork') ") # not already a mutual person
    entity_ids_to_insert.each do |pi|
      MutualNetwork.create!( :entity => self.entity, :human_id => pi["human_id"] )
      #creating reverse relation at the same time
      MutualNetwork.create!( :entity_type => "Person", :entity_id => pi["human_id"], :human_id => self.entity_id )
    end
  end

  def update_mutual_network_after_destroy

    human_networks_to_delete = HumanNetwork.destroy_all("entity_type = 'Person' and entity_id = #{self.entity_id} and human_network_type = 'MutualNetwork' " +# delete all mutual friends
      "and human_id not in (" + # except
      "select distinct(human_id) " + #select all mutual_person ids
      "from human_networks where entity_type = 'Person' and entity_id in " + # person should be friend of
      "(select human_id from human_networks where entity_type = 'Person' and entity_id = #{self.entity_id} and human_network_type = 'TrustedNetwork') " + # current person's friend
      "and human_id not in " + # but should not be
      "(select human_id from human_networks where entity_type = 'Person' and entity_id = #{self.entity_id} and human_network_type = 'TrustedNetwork') " + # friend of current person
      "and human_id != #{self.entity_id} )") # and not current person

    #also delete reverse MUTUAL relations
    human_networks_to_delete = HumanNetwork.destroy_all("human_id = #{self.entity_id} and human_network_type = 'MutualNetwork' " +# delete all mutual friends
      "and entity_type = 'Person' and entity_id not in (" + # except
      "select distinct(human_id) " + #select all mutual_person ids
      "from human_networks where entity_type = 'Person' and entity_id in " + # person should be friend of
      "(select human_id from human_networks where entity_type = 'Person' and entity_id = #{self.entity_id} and human_network_type = 'TrustedNetwork') " + # current person's friend
      "and human_id not in " + # but should not be
      "(select human_id from human_networks where entity_type = 'Person' and entity_id = #{self.entity_id} and human_network_type = 'TrustedNetwork') " + # friend of current person
      "and human_id != #{self.entity_id} )") # and not current person

  end

  
end
