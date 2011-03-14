require "spec_helper"

describe PeopleController do
  describe "routing" do

    it "recognizes and generates #show" do
      { :get => "/people/1" }.should route_to(:controller => "people", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/people/1/edit" }.should route_to(:controller => "people", :action => "edit", :id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "/people/1" }.should route_to(:controller => "people", :action => "update", :id => "1")
    end

    it "recognizes and generates #request_trusted_relationship" do
      { :post => "/people/1/request_trusted_relationship" }.should route_to(:controller => "people", :action => "request_trusted_relationship", :id => "1")
    end

    it "recognizes and generates #cancel_request_trusted_relationship" do
      { :delete => "/people/1/cancel_request_trusted_relationship" }.should route_to(:controller => "people", :action => "cancel_request_trusted_relationship", :id => "1")
    end

  end
end
