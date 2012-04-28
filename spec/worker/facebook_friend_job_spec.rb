require 'spec_helper'

describe FacebookFriendJob do
  it "should create bidirectional relationship for facebook friends of current user" do
    user = Factory :user, :person => Factory(:person)
    friend = Factory :person
    job = FacebookFriendJob.new
    job.user= user
    job.friends= [friend]
    HumanNetwork.facebook_friends.count.should == 0
    job.run
    HumanNetwork.facebook_friends.count.should == 2
    FacebookFriendsJob.where(:user_id => user).count.should == 1
  end
  
  it "should update facebook friends job status if already ran once for user" do
    user = Factory :user, :person => Factory(:person)
    Factory :facebook_friends_job, :user => user, :updated_at => 8.days.ago, :status => "Failure"
    friend = Factory :person
    job = FacebookFriendJob.new
    job.user=user
    job.friends=[friend]
    job.run
    FacebookFriendsJob.where(:user_id => user).count.should == 1
    FacebookFriendsJob.where(:user_id => user).first.status == 'Success'
    
  end
end