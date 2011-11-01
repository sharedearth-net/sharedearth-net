require 'spec_helper'

describe SessionsController do
  include UserSpecHelper
  let(:signedin_user) { generate_mock_user_with_person(:last_activity=>Time.now) }
  let(:mock_current_user) {mock_model(User)}

  describe "GET 'destroy'" do
    def do_get
      get :destroy
    end
		before do
      sign_in_as_user(signedin_user)
    end

    it "should set flash notice and redirect user to root url" do
      do_get
      flash[:notice].should eql(nil)
      response.should redirect_to(root_path)
    end

    it "should remove user_id from session (signout user)" do
      session[:user_id] = 1
      session[:fb_token] = '123'
      do_get
      session[:user_id].should be_nil
    end

    it "should record last user activity" do
      do_get
      signedin_user.last_activity.should_not be_nil
    end
  end

  describe "GET 'create'" do
    before do
      @auth = valid_omniauth_hash
      @user = Factory(:person).user
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

    it "should set flash notice redirect user to root url" do
      do_get
      flash[:notice].should eql(nil)
      response.should redirect_to root_path
    end

    it "should reset person email notification count" do
      do_get
      @user.person.email_notification_count.should eql(0)
    end
  end

end
