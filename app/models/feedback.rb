class Feedback < ActiveRecord::Base
  attr_accessible :item_request_id, :person_id, :feedback, :feedback_note
  belongs_to :item_request
  
  scope :as_person, lambda { |entity| where("person_id = ?", entity.id) }
  
end
