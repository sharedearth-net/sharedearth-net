require "spec_helper"

describe ItemRequestsController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/requests/new" }.should route_to(:controller => "item_requests", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/requests/1" }.should route_to(:controller => "item_requests", :action => "show", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/requests" }.should route_to(:controller => "item_requests", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/requests/1" }.should route_to(:controller => "item_requests", :action => "update", :id => "1")
    end

    it "recognizes and generates #accept" do
      { :put => "/requests/1/accept" }.should route_to(:controller => "item_requests", :action => "accept", :id => "1")
    end

    it "recognizes and generates #reject" do
      { :put => "/requests/1/reject" }.should route_to(:controller => "item_requests", :action => "reject", :id => "1")
    end

    it "recognizes and generates #complete" do
      { :put => "/requests/1/complete" }.should route_to(:controller => "item_requests", :action => "complete", :id => "1")
    end

    it "recognizes and generates #cancel" do
      { :put => "/requests/1/cancel" }.should route_to(:controller => "item_requests", :action => "cancel", :id => "1")
    end

    it "recognizes and generates #collected" do
      { :put => "/requests/1/collected" }.should route_to(:controller => "item_requests", :action => "collected", :id => "1")
    end

  end
end
