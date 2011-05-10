class Feedback < ActiveRecord::Base
  FEEDBACK_POSITIVE  = 10.freeze
  FEEDBACK_NEGATIVE  = 20.freeze
  FEEDBACK_NEUTRAL   = 30.freeze


  FEEDBACK_TYPES = {
    FEEDBACK_POSITIVE  => 'positive',
    FEEDBACK_NEGATIVE   => 'negative',
    FEEDBACK_NEUTRAL  => 'neutral'
  }
  
  attr_accessible :item_request_id, :person_id, :feedback, :feedback_note
  belongs_to :item_request
  belongs_to :person
  
  after_create :feedback_reputation_count
  
  scope :as_person, lambda { |entity| where("person_id = ?", entity.id) }
  scope :for_item_request, lambda { |entity| where("item_request_id = ?", entity.id) }
  
  def feedback_reputation_count
    feedback_person = (self.item_request.requester != self.person)? self.item_request.requester : self.item_request.gifter
    case self.feedback
      when 'positive'
        feedback_person.reputation_rating.increase_positive_feedback_count
      when 'negative'
        feedback_person.reputation_rating.increase_negative_feedback_count
      when 'neutral'
        feedback_person.reputation_rating.increase_neutral_feedback_count
      else
        #
    end
  end
  
  def self.create_default_feedback(person, item_request)
    create! do |feedback|
      feedback.item_request_id = item_request.id
      feedback.person_id = person.id
      feedback.feedback = 'positive'
    end
  end
  
  def self.exists_for?(item_request_id, person_id)
    Feedback.find_by_item_request_id_and_person_id(item_request_id, person_id).nil? ? true : false
  end
  
end