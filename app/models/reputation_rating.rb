class ReputationRating < ActiveRecord::Base
belongs_to :person
validates_presence_of :person_id

  def gift_actions_count
    self.gift_actions
  end
  
  def distinct_people_count
    self.distinct_people
  end
  
  def total_actions_count
    self.total_actions
  end
  
  def positive_feedback_count
    self.positive_feedback
  end
  
  def negative_feedback_count
    self.negative_feedback
  end
  
  def requests_received_count
    self.requests_received
  end
  
  def requests_answered_count
    self.requests_answered
  end
  
  def trusted_network_count_count
    self.trusted_network_count
  end
  
  def activity_level_count
    self.activity_level
  end
end
