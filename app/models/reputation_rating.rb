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
  
  #  PositiveFeedbackRating: = (PositiveFeedback + (NeutralFeedback/2))/TotalActions
  def positive_feedback_rating
    if self.total_actions_count != 0 || self.negative_feedback_count != 0 
      self.positive_feedback_count + (self.negative_feedback_count / 2) / self.total_actions_count
    else
      0
    end
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
    change_activity_level
  end
  
  def increase_requests_answered_count
    self.requests_answered += 1
    save!
    change_activity_level 
  end
  
  def increase_trusted_network_count_count
    self.trusted_network_count += 1
    save!
  end
  
  def decrease_trusted_network_count_count
    self.trusted_network_count -= 1
    save!
  end
  
  def set_activity_level(level)
    self.activity_level = level
    save!
  end
  
  
  def change_activity_level
   if self.requests_received == 0 && self.requests_answered == 0 && self.person.items.count == 0
     self.activity_level = 0
     save!
     return
   elsif self.person.items.count != 0 &&  self.requests_received == 0 && self.requests_answered == 0
     self.activity_level = 1
     save!
     return
   end
    activity = self.requests_received / self.requests_answered
    if activity > 0.5 && activity < 0.8
      self.activity_level = 2
    elsif activity > 0.8
      self.activity_level = 3
    else
       break
    end
    save!      
  end
  
  
end
