class AddReputationToPerson < ActiveRecord::Migration
  def self.up
    people = Person.all
    people.each do | person |
      ReputationRating.create(:person_id => person.id, :gift_actions => 0,:distinct_people => 0, 
                              :total_actions => 0, :positive_feedback => 0, :negative_feedback => 0, :neutral_feedback => 0,
                              :requests_received => 0,  :requests_answered => 0, :trusted_network_count => 0,  :activity_level => 0)
    end
  end

  def self.down
  end
end
