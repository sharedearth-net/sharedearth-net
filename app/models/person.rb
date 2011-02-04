class Person < ActiveRecord::Base
  belongs_to :user
  has_many :items, :as => :owner
  has_many :item_requests, :as => :requester
  has_many :item_gifts, :as => :gifter, :class_name => "ItemRequest"
  
  validates_presence_of :user_id, :name
  
  def belongs_to?(some_user)
    user == some_user
  end
  
  # TODO: maybe convert this to scope
  def all_requests
    item_requests + item_gifts
  end
end
