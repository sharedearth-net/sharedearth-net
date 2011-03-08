class Person < ActiveRecord::Base
  belongs_to :user
  has_many :items, :as => :owner
  has_many :item_requests, :as => :requester
  has_many :item_gifts, :as => :gifter, :class_name => "ItemRequest"
  
  validates_presence_of :user_id, :name
  
  def belongs_to?(some_user)
    user == some_user
  end
  
  def all_item_requests
    ItemRequest.involves(self)
  end

  def active_item_requests
    ItemRequest.involves(self).active.order("created_at DESC")
  end

  def unanswered_requests(requester = nil)
    if requester
      ItemRequest.unanswered.involves(self).involves(requester)
    else
      ItemRequest.unanswered.involves(self)
    end
  end
  
  def avatar(avatar_size = nil)
    self.user.avatar(avatar_size)
  end
end
