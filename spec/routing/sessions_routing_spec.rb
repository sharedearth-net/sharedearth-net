require "spec_helper"

describe SessionsController do
  describe "routing" do

    it "recognizes and generates #create for :provider => 'facebook'" do
      { :get => "/auth/facebook/callback" }.should route_to(:controller => "sessions", :action => "create", :provider => "facebook")
    end

    it "recognizes and generates #destroy" do
      { :get => "/signout" }.should route_to(:controller => "sessions", :action => "destroy")
    end

  end
end
