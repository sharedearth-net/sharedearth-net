require 'fb_service'

class User < ActiveRecord::Base
  has_one :person, :dependent => :destroy

  validates_presence_of :provider, :uid
  validates_uniqueness_of :uid, :scope => :provider
  scope :unactive, where("last_activity < ?", Time.now)

  delegate :network_activity, :to => :person
  delegate :trusted_network_activity, :to => :person

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.create_person(:name  => auth["user_info"]["name"].slice(0..19), 
                         :email => auth["user_info"]["email"],
                         :authorised_account => false)

      user.person.create_reputation_rating(:gift_actions  => 0,:distinct_people => 0, 
                                           :total_actions => 0, :positive_feedback => 0, 
                                           :negative_feedback => 0, :neutral_feedback => 0,
                                           :requests_received => 0, :requests_answered => 0, 
                                           :trusted_network_count => 0,  :activity_level => 0)
    end
    User.find_by_uid(auth["uid"])
  end
  
  # Informs all the authorized user's friends
  def inform_mutural_friends(token)
    if person.authorised_account?
      event_log   = EventLog.fb_friend_join_event_log(person)
      friend_list = FbService.get_my_friends(token)

      friend_list.each do |friend|
        create_fb_event_entity(event_log, friend)
      end 

      create_fb_event_entity(event_log, person)
    end
  end
  
  # Available avatar sizes
  # :square (50x50, Facebook default)
  # :small  (50 pixels wide, variable height)
  # :large (about 200 pixels wide, variable height)
  # :medium (same as :large)
  def avatar(avatar_size = nil)
    avatar_size = :large if avatar_size == :medium # simulate medium size
    "http://graph.facebook.com/#{uid}/picture/"+(!avatar_size.blank? ? "?type=#{avatar_size}" : "")
  end
  
  def validation_failed!
    self.validations_failed += 1
    save!  
    self.lock! if self.validations_failed == 3
  end
  
  def locked?
    if self.lockout.nil?
      false
    elsif (Time.now - self.lockout > 86400)
      self.unlock!
      false
    else
      true  
    end
  end
  
  def unlock!
    self.lockout = nil
    self.validations_failed = 0
    save!    
  end
    
  def lock!
    self.lockout = Time.now
    save!
  end

  def record_last_activity!
    self.last_activity = Time.now
    save!
  end

  def last_activity?
    self.last_activity
  end

  private

  def create_fb_event_entity(event_log, person)
    EventEntity.create!(:event_log => event_log, :entity => person, :user_only => true)
  end
end
