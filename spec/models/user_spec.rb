require 'spec_helper'

module UserSpecHelper

  def valid_user_attributes
    {
      :provider => 'facebook',
      :uid => '111111111',
      :name => 'Slobodan Kovacevic',
      :nickname => 'basti'
    }
  end

  def valid_omniauth_hash
    {
      "provider" => 'facebook',
      "uid" => '111111111',
      "user_info" => {
        "name" => "Slobodan Kovacevic",
        "nickname" => "basti"
      }
    }
  end
end

describe User do
  include UserSpecHelper

  before do
    @user = User.new
  end

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
  
  it "should require name and nickname" do
    @user.should have(1).error_on(:name)
    @user.should have(1).error_on(:nickname)
  end
  
end

describe User, ".create_with_omniauth" do
  include UserSpecHelper
  
  it "should create new user using omniauth hash" do
    lambda {
      User.create_with_omniauth(valid_omniauth_hash)
    }.should change(User, :count)
  end

end
