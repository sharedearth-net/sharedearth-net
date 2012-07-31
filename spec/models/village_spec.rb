require File.dirname(__FILE__) + '/../spec_helper'
module VillageSpecHelper
  def basic_environment
    @user = FactoryGirl.create(:user, :uid => '111')
    @person  = FactoryGirl.create(:person, :users => [@user])
    @other_user = FactoryGirl.create(:user, :uid => '222')
    @other_person  = FactoryGirl.create(:person, :users => [@other_user])
    reputation  = FactoryGirl.create(:reputation_rating, :person_id => @person.id)
    @item        = FactoryGirl.create(:item, :owner => @person)
    @other_item  = FactoryGirl.create(:item, :owner => @other_person)
    @village = FactoryGirl.create(:village)
  end
end

describe Village do
  let(:long_name) {'i' * 51}
  let(:short_name) {'i' * 1}
  it { should validate_presence_of(:country)}
  it { should validate_presence_of(:name)}
  #it { should_not allow_value(:long_name).for(:name)}

end

describe Village, ".join!" do
  include VillageSpecHelper

  before do
    basic_environment
    @village.join!(@person)
  end
  it "adds all items of user who joined/created village" do
    resource = ResourceNetwork.village_resources(@village)
    resource.length.should == 1
  end

  it "adds person to human network connected to village" do
    members = HumanNetwork.village_members(@village)
    members.length.should ==1
  end
end

describe Village, ".add_admin!" do
  include VillageSpecHelper

  before do
    basic_environment
    @village.add_admin!(@person)
  end
  it "adds all items of user who joined/created village" do
    resource = HumanNetwork.village_admins(@village)
    resource.length.should == 1
  end
end

describe Village, ".is_member?" do
  include VillageSpecHelper

  before do
    basic_environment
    @village.join!(@person)
  end
  it "check if is member method is returning correct value" do
    @village.is_member?(@person).should be_true
  end
end

describe Village, ".is_admin?" do
  include VillageSpecHelper

  before do
    basic_environment
    @village.add_admin!(@person)
  end
  it "check if is member method is returning correct value" do
    @village.is_admin?(@person).should be_true
  end
end

describe Village, ".is_member_or_admin?" do
  include VillageSpecHelper

  before do
    basic_environment
  end
  it "check if is member or admin method is returning correct value" do
    @village.add_admin!(@person)
    @village.is_member_or_admin?(@person).should be_true
  end
  it "check if is member or admin method is returning correct value" do
    @village.join!(@person)
    @village.is_member_or_admin?(@person).should be_true
  end
end

describe Village, ".add_items!" do
  include VillageSpecHelper

  before do
    basic_environment
    @village.add_items!(@person)
  end
  it "adds all items of user who joined/created village" do
    resource = ResourceNetwork.village_resources(@village)
    resource.length.should == 1
  end
end

describe Village, ".leave!" do
  include VillageSpecHelper
  context "as regular member" do

    before do
      basic_environment
      @village.join!(@person)
      @village.join!(@other_person)
      @village.join!(@other_person)
      @village.leave!(@person)
    end
    it "removes all items of user who joined/created village connected to village" do
      resource = ResourceNetwork.village_resources(@village)
      resource.length.should == 2
    end

    it "removes user from human network" do
      resource = HumanNetwork.village_members(@village)
      resource.length.should == 2
    end

  end

  context "as group admin" do

    before do
      basic_environment
      @village.add_admin!(@person)
      @village.join!(@other_person)
      @village.leave!(@person)
    end
    it "removes all items of user who joined/created village" do
      resource = ResourceNetwork.village_resources(@village)
      resource.length.should == 1
    end

    it "don't remove regular user from human network" do
      resource = HumanNetwork.village_members(@village)
      resource.length.should == 1
    end

    it "don't allow remove admin user from human network with regular leave method" do
      resource = HumanNetwork.village_admins(@village)
      resource.length.should == 1
    end
  end
end

describe Village, ".add_item!" do
  include VillageSpecHelper

  before do
    basic_environment
    @village.add_item!(@other_item)
  end
  it "adds all items of user who joined/created village" do
    resource = ResourceNetwork.village_resources(@village)
    resource.length.should == 1
  end
end
