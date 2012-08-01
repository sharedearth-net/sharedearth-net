require 'spec_helper'

describe FbFriendsController do
  render_views

  let(:signed_user) { FactoryGirl.create(:user, :person => FactoryGirl.create(:person)) } #FactoryGirl.create(:person, :users => [FactoryGirl.create(:user)]).users.first }

  let(:juan) { FactoryGirl.create(:person, :users => [signed_user]) }

  before :each do
    sign_in_as_user(signed_user)
  end

  describe "GET 'index'" do
    before :each do
      FbService.stub_chain(:get_my_friends, :order).and_return([juan])
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should list all my fb friends" do
      get :index
      response.body.should match juan.name
    end
  end

  describe "GET 'search'" do
    let(:maria)     { FactoryGirl.create(:person, :name => 'Maria') }

    let(:marceline) { FactoryGirl.create(:person, :name => 'Marceline') }

    let(:pedro)     { FactoryGirl.create(:person, :name => 'Pedro') }

    before :each do
      FbService.stub(:search_fb_friends).and_return([marceline])
    end

    it "should be successful" do
      get :search_fb_friends, :search_terms => ''
      response.should be_success
    end

    it "should render the right template" do
      get :search_fb_friends, :search_terms => ''
      response.should render_template :index
    end

    it "should do the search only on my FB friends" do
      get :search_fb_friends, :search_terms => 'Mar'
      response.body.should match marceline.name
      response.body.should_not match pedro.name
      response.body.should_not match maria.name
    end
  end
end
