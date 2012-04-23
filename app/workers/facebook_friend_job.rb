require 'iron_worker'

class FacebookFriendJob < IronWorker::Base
  merge "../models/human_network.rb"
  merge "../models/facebook_friends_job.rb"
  attr_accessor :user, :friends

  def run
    friends.each do |friend|
      HumanNetwork.create_facebook_friends!(user.person, friend)
    end
    
    if FacebookFriendsJob.where(:user_id => user).present?
      job = FacebookFriendsJob.where(:user_id => user).first
    else
      job = FacebookFriendsJob.new
      job.user = user
    end
    job.status = 'Success'
    job.save
  end

end