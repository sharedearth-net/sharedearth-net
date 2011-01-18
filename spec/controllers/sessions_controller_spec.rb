require 'spec_helper'

describe SessionsController do

  describe "GET 'destroy'" do
    def do_get
      get :destroy
    end
    
    it "should redirect user to root url" do
      do_get
      response.should redirect_to(root_path)
    end

    it "should remove user_id from session (signout user)" do
      session[:user_id] = 1
      do_get
      session[:user_id].should be_nil
    end
  end

  describe "GET 'create'" do
    before do
      @auth = {"provider" => "facebook", "uid" => "111111", "user_info" => { "name" => "Slobodan Kovacevic", "nickname" => "basti" } }
      @user = mock_model(User)
      request.stub!(:env).and_return({ "omniauth.auth" => @auth })
    end
    
    def do_get
      get :create, :provider => "facebook" 
    end
    
    it "should create new user (if user doesn't exist)" do
      User.should_receive(:find_by_provider_and_uid).with(@auth["provider"], @auth["uid"]).and_return(nil)
      User.should_receive(:create_with_omniauth).with(@auth).and_return(@user)
      do_get
    end
    
    it "should find existing user" do
      User.should_receive(:find_by_provider_and_uid).with(@auth["provider"], @auth["uid"]).and_return(@user)
      User.should_not_receive(:create_with_omniauth)
      do_get
    end
    
    it "should sign in user" do
      session[:user_id] = nil
      do_get
      session[:user_id].should_not be_nil
    end

    it "should redirect user to root url" do
      do_get
      response.should redirect_to(root_path)
    end
  end
  
end

describe SessionsController, "#route_for" do

  it "should map { :controller => 'sessions', :action => 'create', :provider => 'facebook' } to /auth/facebook/callback" do
    { :get => "/auth/facebook/callback" }.should route_to(:controller => "sessions", :action => "create", :provider => "facebook")
  end

  it "should map { :controller => 'sessions', :action => 'destroy' } to /signout" do
    { :get => "/signout" }.should route_to(:controller => "sessions", :action => "destroy")
  end

end