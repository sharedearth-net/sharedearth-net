class NetworkRequest < ActiveRecord::Base
  belongs_to :person
  belongs_to :trusted_person, :class_name => "Person"
  
  validates_presence_of :person_id, :trusted_person_id
  
  def requester?(person)
    self.person == person
  end

  def trusted_person?(person)
    self.trusted_person == person
  end

  def confirm!
    PeopleNetwork.create_trust!(self.person, self.trusted_person) 
    self.destroy
  end
end
