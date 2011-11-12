require 'spec_helper'

describe User do
  include UserSpecHelper

  before do
    @user = User.new
  end

  it { should have_one(:person) }

  it "should be valid" do
    @user.attributes = valid_user_attributes
    @user.should be_valid
  end

  it "should require provider" do
    @user.should have(1).error_on(:provider)
  end

  it "should require uid" do
    @user.should have(1).error_on(:uid)
  end

  it "should have unique uid in provider scope" do
    User.create!(valid_user_attributes)
    @user.attributes = valid_user_attributes
    @user.should_not be_valid
    @user.should have(1).error_on(:uid)
  end

  it "should not require nickname" do
    @user.should have(0).error_on(:nickname)
  end

end

describe User, ".create_with_omniauth" do
  include UserSpecHelper
  before(:each) do
    FbService.stub!(:post_on_my_wall).and_return(true)
  end

  it "should create new user using omniauth hash" do
    expect {
      User.create_with_omniauth(valid_omniauth_hash)
    }.should change(User, :count).by(1)
  end

  it "should create new person for this new user" do
    expect {
      User.create_with_omniauth(valid_omniauth_hash)
    }.should change(Person.unscoped, :count).by(1)
  end

  it "should take only the first 20 chars from the provided name" do
    truncated_name = valid_omniauth_hash["user_info"]["name"].slice(0..19)
    new_user = User.create_with_omniauth(valid_omniauth_hash)
    new_user.person.name.should match truncated_name
  end
end

describe User, ".avatar" do
  include UserSpecHelper

  it "should return Facebook avatar URL" do
    valid_user = User.new(valid_user_attributes)
    valid_user.avatar.should eql("http://graph.facebook.com/#{valid_user_attributes[:uid]}/picture/")
  end

  it "should return URL for different Facebook avatar sizes" do
    valid_user = User.new(valid_user_attributes)
    ["square", "small", "large"].each do |avatar_size|
      valid_user.avatar(avatar_size).should eql("http://graph.facebook.com/#{valid_user_attributes[:uid]}/picture/?type=#{avatar_size}")
    end
  end
end

describe User, ".inform_mutual_friends" do
  let(:juan)  { Factory(:person) }

  let(:maria) { Factory(:person) }

  let(:pedro) { Factory(:person) }

  let(:jose) { Factory(:person, :authorised_account => false) }

  let(:token) { '123abc' }

  before :each do
    # I hate using mocks, but it seems there's no other way around this =/
    fb_pedro_user = mock('fb_pedro_user', { :identifier => pedro.user.uid })
    fb_juan_user  = mock('fb_juan_user',  { :identifier => juan.user.uid })
    fb_maria_user = mock('fb_maria_user', { :identifier => maria.user.uid })
    fb_jose_user = mock('fb_jose_user',   { :identifier => jose.user.uid })

    fb_registered_user = mock('fb_registered_user')
    fb_registered_user.stub(:friends).and_return([fb_pedro_user, fb_maria_user, fb_jose_user ])

    FbGraph::User.stub!(:me).and_return(fb_registered_user)
  end

  context "Authorized User" do
    before :each do
      juan.user.inform_mutural_friends(token)
    end

    it "should create only one Event Log that relates to this event" do
      expect {
        juan.user.inform_mutural_friends(token)
      }.to change { EventLog.count }.by(1)
    end

    it "should create an Event Entity associated with each of its authorized friends" do
      EventEntity.where(:entity_id => maria.id).should_not be_empty
      EventEntity.where(:entity_id => pedro.id).should_not be_empty
      EventEntity.where(:entity_id => jose.id).should be_empty
    end

    it "should not create duplicated event logs" do
      EventEntity.where(:entity_id => juan.id).size.should == 1
    end
  end

describe "Scopes" do

    describe "#unactive scope" do
      before :each do
        @first_user  = Factory.create(:user, :last_activity => Time.now)
        @second_user = Factory.create(:user, :last_activity => (Time.now - 13.hours))
      end

      it "should return a list of comments ordered by creation date" do
        users = User.unactive
        users.should == [@second_user]
      end
    end
end
end
