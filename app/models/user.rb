class User < ActiveRecord::Base
  has_one :person

  validates_presence_of :provider, :uid, :nickname
  validates_uniqueness_of :uid, :scope => :provider

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.nickname = auth["user_info"]["nickname"]
      user.create_person(:name => auth["user_info"]["name"])
    end
  end
  
  def avatar
    "http://graph.facebook.com/#{nickname}/picture"
  end
end
