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
  
  after_create :feedback_reputation_count, :if => :both_parties_left_feedback?
  #TEMPORARY REMOVED, ADD NEW EVENT LOG TYPES FIRST WITH MIGRATION
  after_create :post_feedback_activity_and_event_logs, :if => :both_parties_left_feedback?

  validates_length_of   :feedback_note, :maximum => 400, :if => :neutral_or_negative?
  validates_presence_of :feedback_note, :if => :neutral_or_negative?
  validates_presence_of :feedback
  
  scope :as_person, lambda { |entity| where("person_id = ?", entity.id) }
  scope :for_item_request, lambda { |entity| where("item_request_id = ?", entity.id) }
  
  def feedback_reputation_count
    self.item_request.feedbacks.each do |feedback|
      if feedback.person_id == self.item_request.requester.id
        feedback_person = self.item_request.gifter
      else
        feedback_person = self.item_request.requester
      end
      case feedback.feedback.to_i
        when FEEDBACK_POSITIVE
          feedback_person.reputation_rating.increase_positive_feedback_count
        when FEEDBACK_NEGATIVE
          feedback_person.reputation_rating.increase_negative_feedback_count
        when FEEDBACK_NEUTRAL
          feedback_person.reputation_rating.increase_neutral_feedback_count
        else
          #
      end
    end
  end
  
  def both_parties_left_feedback?
    self.item_request.both_parties_left_feedback?
  end
  
  def neutral_or_negative?
    self.feedback.to_i == FEEDBACK_NEGATIVE || self.feedback.to_i == FEEDBACK_NEUTRAL
  end
  
  def self.create_default_feedback(person, item_request)
    create! do |feedback|
      feedback.item_request_id = item_request.id
      feedback.person_id = person.id
      feedback.feedback = FEEDBACK_POSITIVE
    end
  end
  
  def self.exists_for?(item_request_id, person_id)
    Feedback.find_by_item_request_id_and_person_id(item_request_id, person_id).nil? ? true : false
  end
  
  def feedback_mark_from(item_request_id, person_id)
    Feedback.find_by_item_request_id_and_person_id(item_request_id, person_id)
  end
  
  def post_feedback_activity_and_event_logs
    self.item_request.feedbacks.each do |feedback|
      case feedback.feedback.to_i
        when FEEDBACK_POSITIVE 
          if item_request.item.purpose == 10
            if feedback.person_id == self.item_request.gifter_id
              ActivityLog.create_item_request_activity_log(self.item_request, EventType.gifter_positive_feedback_gifter, EventType.gifter_positive_feedback_requester)
              EventLog.create_news_event_log(self.item_request.gifter, self.item_request.requester, self.item_request.item, EventType.gifter_positive_feedback_gifter, nil)
            elsif feedback.person_id == self.item_request.requester_id
              ActivityLog.create_item_request_activity_log(self.item_request, EventType.requester_positive_feedback_requester, EventType.requester_positive_feedback_gifter)
              EventLog.create_news_event_log(self.item_request.requester, self.item_request.gifter, self.item_request.item, EventType.requester_positive_feedback_requester, nil)
            else
              #
            end 
		  elsif item_request.item.purpose == 20
			if feedback.person_id == self.item_request.gifter_id
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.gift_gifter_positive_feedback_gifter, EventType.gift_gifter_positive_feedback_requester)
			  EventLog.create_news_event_log(self.item_request.gifter, self.item_request.requester, self.item_request.item, EventType.gift_gifter_positive_feedback_gifter, nil)
			elsif feedback.person_id == self.item_request.requester_id
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.gift_requester_positive_feedback_requester, EventType.gift_requester_positive_feedback_gifter)
			  EventLog.create_news_event_log(self.item_request.requester, self.item_request.gifter, self.item_request.item, EventType.gift_requester_positive_feedback_requester, nil)
			else
			  #
			end
	      elsif item_request.item.purpose == 30
			if feedback.person_id == self.item_request.gifter_id
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.shareage_gifter_positive_feedback_gifter, EventType.shareage_gifter_positive_feedback_requester)
			  EventLog.create_news_event_log(self.item_request.gifter, self.item_request.requester, self.item_request.item, EventType.shareage_gifter_positive_feedback_gifter, nil)
		    elsif feedback.person_id == self.item_request.requester_id
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.shareage_requester_positive_feedback_requester, EventType.shareage_requester_positive_feedback_gifter)
			  EventLog.create_news_event_log(self.item_request.requester, self.item_request.gifter, self.item_request.item, EventType.shareage_requester_positive_feedback_requester, nil)
		    else
			  #
			end 
		  else
			#
		  end
        when FEEDBACK_NEGATIVE
          if item_request.item.purpose == 10 
            if feedback.person_id == self.item_request.gifter_id 
              ActivityLog.create_item_request_activity_log(self.item_request, EventType.gifter_negative_feedback_gifter, EventType.gifter_negative_feedback_requester)
              EventLog.create_news_event_log(self.item_request.gifter, self.item_request.requester, self.item_request.item, EventType.gifter_negative_feedback_gifter, nil)
            elsif feedback.person_id == self.item_request.requester_id
              ActivityLog.create_item_request_activity_log(self.item_request, EventType.requester_negative_feedback_requester, EventType.requester_negative_feedback_gifter)
              EventLog.create_news_event_log(self.item_request.requester, self.item_request.gifter, self.item_request.item, EventType.requester_negative_feedback_requester, nil)
            else
              #
            end
		  elsif item_request.item.purpose == 20
			if feedback.person_id == self.item_request.gifter_id
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.gift_gifter_negative_feedback_gifter, EventType.gift_gifter_negative_feedback_requester)
			  EventLog.create_news_event_log(self.item_request.gifter, self.item_request.requester, self.item_request.item, EventType.gift_gifter_negative_feedback_gifter, nil)
			elsif feedback.person_id == self.item_request.requester_id
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.gift_requester_negative_feedback_requester, EventType.gift_requester_negative_feedback_gifter)
			  EventLog.create_news_event_log(self.item_request.requester, self.item_request.gifter, self.item_request.item, EventType.gift_requester_negative_feedback_requester, nil)
			else
			  #
			end
		  elsif item_request.item.purpose == 30
			if feedback.person_id == self.item_request.gifter_id
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.shareage_gifter_negative_feedback_gifter, EventType.shareage_gifter_negative_feedback_requester)
			  EventLog.create_news_event_log(self.item_request.gifter, self.item_request.requester, self.item_request.item, EventType.shareage_gifter_negative_feedback_gifter, nil)
			elsif feedback.person_id == self.item_request.requester_id
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.shareage_requester_negative_feedback_requester, EventType.shareage_requester_negative_feedback_gifter)
			  EventLog.create_news_event_log(self.item_request.requester, self.item_request.gifter, self.item_request.item, EventType.shareage_requester_negative_feedback_requester, nil)
			else
			  #
			end
          end 
        when FEEDBACK_NEUTRAL
          if item_request.item.purpose == 10 
            if feedback.person_id == self.item_request.gifter_id
              ActivityLog.create_item_request_activity_log(self.item_request, EventType.gifter_neutral_feedback_gifter, EventType.gifter_neutral_feedback_requester)
              EventLog.create_news_event_log(self.item_request.gifter, self.item_request.requester, self.item_request.item, EventType.gifter_neutral_feedback_gifter, nil)
            elsif feedback.person_id == self.item_request.requester_id
              ActivityLog.create_item_request_activity_log(self.item_request, EventType.requester_neutral_feedback_requester, EventType.requester_neutral_feedback_gifter)
              EventLog.create_news_event_log(self.item_request.requester, self.item_request.gifter, self.item_request.item, EventType.requester_neutral_feedback_requester, nil)
            else
              #
            end
	      elsif item_request.item.purpose == 20
		    if feedback.person_id == self.item_request.gifter_id
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.gift_gifter_neutral_feedback_gifter, EventType.gift_gifter_neutral_feedback_requester)
			  EventLog.create_news_event_log(self.item_request.gifter, self.item_request.requester, self.item_request.item, EventType.gift_gifter_neutral_feedback_gifter, nil)
			elsif feedback.person_id == self.item_request.requester_id
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.gift_requester_neutral_feedback_requester, EventType.gift_requester_neutral_feedback_gifter)
			  EventLog.create_news_event_log(self.item_request.requester, self.item_request.gifter, self.item_request.item, EventType.gift_requester_neutral_feedback_requester, nil)
			else
			  #
			end
	      elsif item_request.item.purpose == 30
		    if feedback.person_id == self.item_request.gifter_id
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.shareage_gifter_neutral_feedback_gifter, EventType.shareage_gifter_neutral_feedback_requester)
			  EventLog.create_news_event_log(self.item_request.gifter, self.item_request.requester, self.item_request.item, EventType.shareage_gifter_neutral_feedback_gifter, nil)
			elsif
			  ActivityLog.create_item_request_activity_log(self.item_request, EventType.shareage_requester_neutral_feedback_requester, EventType.shareage_requester_neutral_feedback_gifter)
			  EventLog.create_news_event_log(self.item_request.requester, self.item_request.gifter, self.item_request.item, EventType.shareage_requester_neutral_feedback_requester, nil)
			else
			  #
			end
	      else
			#
	      end 
        else
          #
      end
    end 
  end
  
  def requester_feedback?
    self.person_id == self.item_request.requester.id
  end
  
end
