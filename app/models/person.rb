class Person < ActiveRecord::Base
  belongs_to :user
  has_many :items, :as => :owner
  
  validates_presence_of :user_id
end
