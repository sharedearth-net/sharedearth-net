require File.dirname(__FILE__) + '/../spec_helper'
module HumanNetworkSpecHelper
  def basic_environment
    @user = Factory(:user, :uid => '111')
    @person  = Factory(:person, :user => @user)
    reputation  = Factory(:reputation_rating, :person_id => @person.id)
    @item        = Factory(:item, :owner => @person)
    @other_item  = Factory(:item)
    @village = Factory(:village)
  end
end

describe HumanNetwork do
  it "should be valid" do
    HumanNetwork.new.should_not be_valid
  end

end

describe HumanNetwork, ".join!" do
  include HumanNetworkSpecHelper

  before do
    basic_environment
    @village.join!(@person)
  end
  it "adds user to human network who joined/created village" do
    members = HumanNetwork.village_members(@village)
    members.length.should == 1
  end
end

describe HumanNetwork, ".leave!" do
  include HumanNetworkSpecHelper

  before do
    basic_environment
    @village.join!(@person)
    @village.leave!(@person)
  end
  it "removes user from human network when leaving village" do
    members = HumanNetwork.village_members(@village)
    members.length.should == 0
  end
end

describe HumanNetwork, ".add_item!" do
  include HumanNetworkSpecHelper

  before do
    basic_environment
    @village.add_item!(@other_item)
  end
  it "adds all items of user who joined/created village" do
    Human = ResourceNetwork.village_resources(@village)
    Human.length.should == 1
  end
end

describe "Facebook Friends" do
  it "should find all facebook friends in network" do
    Factory :human_network
    Factory :facebook_friend_network
    HumanNetwork.facebook_friends.count.should == 1
    HumanNetwork.facebook_friends.first.network_type.should == "FacebookFriend"
  end
end

describe "create facebook friends" do
  it "should create mutual facebook friends" do
    first = Factory :person
    second = Factory :person
    HumanNetwork.facebook_friends.count.should == 0
    
    HumanNetwork.create_facebook_friends!(first, second)
    HumanNetwork.facebook_friends.count.should == 2
  end
  
  it "should not create mutual facebook friends when already exists" do
    first = Factory :person
    second = Factory :person
    Factory :facebook_friend_network, :entity => first, :person => second
    HumanNetwork.facebook_friends.count.should == 1
    
    HumanNetwork.create_facebook_friends!(first, second)
    HumanNetwork.facebook_friends.count.should == 1
  end
end


