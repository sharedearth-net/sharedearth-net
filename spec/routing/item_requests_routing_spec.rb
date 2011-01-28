require "spec_helper"

describe ItemRequestsController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/request/new" }.should route_to(:controller => "item_requests", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/request/1" }.should route_to(:controller => "item_requests", :action => "show", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/request" }.should route_to(:controller => "item_requests", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/request/1" }.should route_to(:controller => "item_requests", :action => "update", :id => "1")
    end

  end
end
