class AddReputationValuesToPerson < ActiveRecord::Migration
  #New table reputation is added, and now update those values for each person based on their history
  def self.up
  people = Person.all
    people.each do | person |
      gift_actions = ItemRequest.find(:all, :conditions => ["gifter_id=? and gifter_type=? and status=?", person.id, "Person", ItemRequest::STATUS_COMPLETED]).size
      people_helped = ItemRequest.find(:all, :select => 'DISTINCT requester_id', :conditions => ["gifter_id=? and gifter_type=?", person.id, "Person"]).size
      answered = ItemRequest.answered_gifter(person).size
      requests_received = ItemRequest.involves_as_gifter(person).size
      total =  ItemRequest.involves(person).size
      person.reputation_rating.update_attributes(:gift_actions => gift_actions, :distinct_people => people_helped, 
                        :total_actions => total, :requests_received => requests_received, :requests_answered => answered)                        
    end
  end

  def self.down
  end
end
