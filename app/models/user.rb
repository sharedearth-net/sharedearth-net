class User < ActiveRecord::Base
  has_one :person, :dependent => :destroy

  validates_presence_of :provider, :uid
  validates_uniqueness_of :uid, :scope => :provider

  delegate :network_activity, :to => :person

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.create_person(:name => auth["user_info"]["name"].slice(0..19), :email => auth["user_info"]["email"])
      user.person.create_reputation_rating(:gift_actions => 0,:distinct_people => 0, 
                              :total_actions => 0, :positive_feedback => 0, :negative_feedback => 0, :neutral_feedback => 0,
                              :requests_received => 0,  :requests_answered => 0, :trusted_network_count => 0,  :activity_level => 0)
    end
    user = User.find_by_uid(auth["uid"])
    #IF STATEMENT IS ONLY FOR BETA PHASE BECAUSE INFORMING MUTUAL FRIENDS WILL BE DONE WHEN ENTERED PROPER CODE
    user.inform_mutural_friends(auth["credentials"]["token"]) if user.person.authorised?
    user
  end
  
  #Inform everybody if this person is their friend on fb
  def inform_mutural_friends(token)
    registered_user = FbGraph::User.me(token)
    event_log = nil

    begin
      friends_list = registered_user.friends(options = {:access_token => token})  
    rescue
      puts "Access token was incorrect"
    end

    unless friends_list.nil?
      friends_list.each do |friend|

        connection = User.find(:first, :conditions => ['uid = ?', friend.identifier])
        next if connection.nil?

        #First parameter user that joined, second person that is informed
        event_log = EventLog.fb_friend_join_event_log(self.person, connection.person, 
                                                      EventType.fb_friend_join)
        EventEntity.create!(:event_log => event_log, :entity => connection.person, 
                            :user_only => true)
      end 

      unless event_log.nil?
        EventEntity.create!(:event_log => event_log, :entity => self.person, 
                            :user_only => true)  
      end
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
end
