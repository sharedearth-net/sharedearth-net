require 'fb_service'

class User < ActiveRecord::Base
  has_one :person, :dependent => :destroy

  validates :email, :uniqueness => true, :email => true,                            :if => :classic_sing_up_now?
  validates :password, :presence => true, :length => 6..32, :confirmation => true,  :if => :classic_sing_up_now?
  validates :name, :length => 3..19, :presence => true,                             :if => :classic_sing_up_now?

  validates_presence_of :provider, :uid,                :unless => :classic_sing_up?
  validates_uniqueness_of :uid, :scope => :provider,    :unless => :classic_sing_up?

  attr_accessor :password, :password_confirmation, :classic_sing_up, :name

  scope :unactive, where("last_activity < ?", Time.now - 12.hours)

  delegate :network_activity, :to => :person
  delegate :trusted_network_activity, :to => :person

  before_save :check_classic_sign_up,     :if => :classic_sing_up?
  after_create  :create_new_person,       :if => :classic_sing_up?
  after_create  :send_confirmation_email, :if => :classic_sing_up?

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.create_person(:name  => auth["info"]["name"].slice(0..19), 
                         :email => auth["info"]["email"],
                         :authorised_account => true)

      user.person.create_staring_reputation_rating!
    end
    User.find_by_uid(auth["uid"])
  end

  def self.try_auth(email, password)
    where(:email => email, :encrypted_password => encrypt_string(password)).first
  end

  def classic_sing_up?
    @classic_sing_up || email.present? && encrypted_password.present?
  end

  def classic_sing_up_now?
    classic_sing_up? && new_record?
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

  def email_confirmation_code
    self.class.encrypt_string(encrypted_password)
  end

  def verify_email!(code)
    if !verified_email? && code == email_confirmation_code
      update_attribute(:verified_email, 1)
      true
    else
      false
    end
  end

  private

  def create_fb_event_entity(event_log, person)
    EventEntity.create!(:event_log => event_log, :entity => person, :user_only => true)
  end

  def check_classic_sign_up
    self.provider ||= "email_and_password"
    self.encrypted_password ||= self.class.encrypt_string(password)
  end

  def create_new_person
    create_person(:name => self.name, :email => self.email, :authorised_account => true)
    user.person.create_staring_reputation_rating!
  end

  def send_confirmation_email
    if email.present?
      UserMailer.registration_cofirmation(self).deliver!
    end
  end

  def self.encrypt_string(pass)
    Digest::SHA2.hexdigest(pass)
  end
end
