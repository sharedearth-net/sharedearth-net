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
    truncated_name = valid_omniauth_hash["user_info"]["name"].slice(0..20)
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
