require 'spec_helper'

module UserSpecHelper

  def valid_user_attributes
    {
      :provider => 'facebook',
      :uid => '111111111'
    }
  end

  def valid_omniauth_hash
    {
      "provider" => 'facebook',
      "uid" => '111111111',
      "user_info" => {
        "name" => "Slobodan Kovacevic",
        "nickname" => "basti"
      },
      "credentials" => {
        "token" => "111111111"
      },
      "extra" => {
        "email" => "testing@test.net"
      }
    }
  end
end

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
  
  it "should create new user using omniauth hash" do
    expect {
      User.create_with_omniauth(valid_omniauth_hash)
    }.should change(User, :count).by(1)
  end
  
  it "should create new person for this new user" do
    expect {
      User.create_with_omniauth(valid_omniauth_hash)
    }.should change(Person, :count).by(1) 
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

  let(:token) { '123abc' }

  before :each do
    # I hate using mocks, but it seems there's no other way around this =/
    fb_pedro_user = mock('fb_pedro_user', { :identifier => pedro.user.uid })
    fb_juan_user  = mock('fb_juan_user',  { :identifier => juan.user.uid })
    fb_maria_user = mock('fb_maria_user', { :identifier => maria.user.uid })

    fb_registered_user = mock('fb_registered_user')
    fb_registered_user.stub(:friends).and_return([fb_pedro_user, fb_maria_user])

    FbGraph::User.stub!(:me).and_return(fb_registered_user)
  end
  
  context "When Juan joins sharedearth" do
    before :each do
      juan.user.inform_mutural_friends(token)
    end

    it "should create an event log notifying Maria" do
      the_logs = EventLog.where(:primary_id  => juan.id).
                          where(:secondary_id => maria.id)  
      the_logs.should_not be_empty
    end
    
    it "should create an event log notifying Pedro" do
      the_logs = EventLog.where(:primary_id  => juan.id).
                          where(:secondary_id => pedro.id)  
      the_logs.should_not be_empty    
    end

    it "should not create duplicated event logs" do
      EventEntity.where(:entity_id => juan.id).size.should == 1
    end
  end
end
