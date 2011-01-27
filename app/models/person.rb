class Person < ActiveRecord::Base
  belongs_to :user
  has_many :items, :as => :owner
  
  validates_presence_of :user_id, :name
  
  def belongs_to?(some_user)
    user == some_user
  end
end
