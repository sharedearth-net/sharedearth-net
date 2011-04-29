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
  
  def increase_gift_actions_count
    self.gift_actions += 1
    save!
  end
  
  def increase_distinct_people_count
    self.distinct_people += 1
    save!
  end
  
  def increase_total_actions_count
    self.total_actions += 1
    save!
  end
  
  def increase_positive_feedback_count
    self.positive_feedback += 1
    save!
  end
  
  def increase_negative_feedback_count
    self.negative_feedback += 1
    save!
  end
  
  def increase_requests_received_count
    self.requests_received += 1
    save!
  end
  
  def increase_requests_answered_count
    self.requests_answered += 1
    save!
  end
  
  def increase_trusted_network_count_count
    self.trusted_network_count += 1
    save!
  end
  
  def increase_activity_level_count
    self.activity_level += 1
    save!
  end
  
  
end
