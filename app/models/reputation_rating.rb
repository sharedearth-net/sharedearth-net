class ReputationRating < ActiveRecord::Base
belongs_to :person
validates_presence_of :person_id
end
