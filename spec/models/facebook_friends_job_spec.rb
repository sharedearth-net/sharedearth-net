require 'spec_helper'

describe FacebookFriendsJob do
  it { should belong_to(:user) }
  
  describe "week since last run" do
    it "should return true if last run for job was more than a week old" do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:facebook_friends_job, :user => user, :updated_at => 8.days.ago)
      FacebookFriendsJob.week_since_last_run?(user).should be_true
    end
    
    it "should return true if no job found for the user" do
      user = FactoryGirl.create(:user)
      FacebookFriendsJob.week_since_last_run?(user).should be_true
    end
    
    it "should return false if last run for job was lesser than one week ago" do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:facebook_friends_job, :user => user)
      FacebookFriendsJob.week_since_last_run?(user).should be_false
    end
  end
end