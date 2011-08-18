require 'spec_helper'

describe FbService, ".fb_logout_url" do

  let(:fb_session_key)  { '123abc' }

  let(:fb_api_key)      { 'zyx123' }

  let(:return_url)      { 'www.google.com' }

  let(:corret_logout_url) {
    "http://www.facebook.com/logout.php?" << 
    "api_key=#{fb_api_key}" <<
    "&session_key=#{fb_session_key}&" <<
    "confirm=1&next=#{return_url}"
  }

  it "should return the right Fb logout url" do
    log_out_url = FbService.fb_logout_url(fb_api_key, fb_session_key, return_url)
    log_out_url.should == corret_logout_url
  end
end

describe FbService, ".get_fb_friends_from" do
  let(:token) { '123abc' }

  let(:mock_fb_user) { mock 'fb_user' }

  let(:mock_fb_friends) { [mock('fb_friend_one'), mock('fb_friend_two')] }

  context "When using an invalid access token" do
    before :each do
      # I hate using mocks =/
      mock_fb_user.stub(:friends).and_raise 'Lol'
      FbService.stub(:fb_user_from).and_return(mock_fb_user)
    end

    it "should return an empty list" do
      FbService.fb_friends_from(token).should be_empty
    end
  end

  context "When using a valid access token" do
    before :each do
      mock_fb_user.stub(:friends).and_return(mock_fb_friends)
      FbService.stub(:fb_user_from).and_return(mock_fb_user)
    end

    it "should return a list with all my fb friends" do
      FbService.fb_friends_from(token).should_not be_empty
    end
  end
end

describe FbService, ".people_from_fb_friends" do
  let(:first_fb_friend) { mock 'first_fb_friend' }

  let(:second_fb_friend) { mock 'second_fb_friend' }

  let(:fb_friends) { [first_fb_friend, second_fb_friend] }

  let(:first_person) { Factory(:person) }

  let(:second_person) { Factory(:person) }

  before :each do
    first_fb_friend.stub(:identifier).and_return(first_person.user.uid)
    second_fb_friend.stub(:identifier).and_return(second_person.user.uid)
  end

  it "should return a list of people based on the provided fb friend list" do
    FbService.people_from_fb_friends(fb_friends).should include first_person
    FbService.people_from_fb_friends(fb_friends).should include second_person
  end
end

describe FbService, ".get_my_friends" do
  # Yuck!
  let(:first_fb_friend) { mock 'first_fb_friend' }

  let(:second_fb_friend) { mock 'second_fb_friend' }

  let(:third_fb_friend) { mock 'third_fb_friend' }

  let(:fb_friends) { [first_fb_friend, second_fb_friend, third_fb_friend] }

  let(:jake) { Factory(:person, :name => 'jake') }

  let(:joseph) { Factory(:person, :name => 'joseph') }

  let(:bill) { Factory(:person, :name => 'bill', :authorised_account => false) }

  before :each do
    first_fb_friend.stub(:identifier).and_return(jake.user.uid)
    second_fb_friend.stub(:identifier).and_return(joseph.user.uid)
    third_fb_friend.stub(:identifier).and_return(bill.user.uid)
    FbService.stub(:fb_friends_from).and_return(fb_friends)
  end

  it "should return a list of all the authorized people associated with my fb friends" do
    friends = FbService.get_my_friends('123')
    friends.should == [jake, joseph]
  end
end
