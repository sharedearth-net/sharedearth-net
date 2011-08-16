require 'spec_helper'

describe FbFriendsController do
  render_views

  let(:signed_user) { Factory(:person).user }

  let(:juan) { Factory(:person) }

  before :each do
    sign_in_as_user(signed_user)
  end

  describe "GET 'index'" do
    before :each do
      FbService.stub(:get_my_friends).and_return([juan])
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
    let(:maria)     { Factory(:person, :name => 'Maria') }

    let(:marceline) { Factory(:person, :name => 'Marceline') }

    let(:pedro)     { Factory(:person, :name => 'Pedro') }

    before :each do
      FbService.stub(:get_my_friends).and_return([marceline, pedro])
    end

    it "should be successful" do
      get :search, :search_terms => ''
      response.should be_success
    end

    it "should render the right template" do
      get :search, :search_terms => ''
      response.should render_template :index
    end

    it "should do the search only on my FB friends" do
      get :search, :search_terms => 'Mar'
      response.body.should match marceline.name
      response.body.should_not match pedro.name
      response.body.should_not match maria.name
    end
  end
end
