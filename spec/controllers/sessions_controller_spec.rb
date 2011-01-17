require 'spec_helper'

describe SessionsController do

  # it "should remove user_id from session and redirect to root url"
  
  # response.should render_template("layouts/some_layout") 
  
end

describe SessionsController, "#route_for" do

  it "should map { :controller => 'sessions', :action => 'create', :provider => 'facebook' } to /auth/facebook/callback" do
    { :get => "/auth/facebook/callback" }.should route_to(:controller => "sessions", :action => "create", :provider => "facebook")
  end

  it "should map { :controller => 'sessions', :action => 'destroy' } to /signout" do
    { :get => "/signout" }.should route_to(:controller => "sessions", :action => "destroy")
  end

end