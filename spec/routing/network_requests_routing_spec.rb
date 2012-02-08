require "spec_helper"

describe HumanNetworkController do
  describe "routing" do

    it "recognizes and generates #create" do
      { :post => "/network_requests" }.should route_to(:controller => "network_requests", :action => "create")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/network_requests/1" }.should route_to(:controller => "network_requests", :action => "destroy", :id => "1")
    end

    it "recognizes and generates #confirm" do
      { :put => "/network_requests/1/confirm" }.should route_to(:controller => "network_requests", :action => "confirm", :id => "1")
    end

    it "recognizes and generates #deny" do
      { :put => "/network_requests/1/deny" }.should route_to(:controller => "network_requests", :action => "destroy", :id => "1")
    end

  end
end
