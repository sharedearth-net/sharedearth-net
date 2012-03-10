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
    HumanNetwork.new.should be_valid
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
    Human = HumanNetwork.village_Humans(@village)
    Human.length.should == 1
  end
end
