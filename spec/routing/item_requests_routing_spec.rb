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

  end
end
