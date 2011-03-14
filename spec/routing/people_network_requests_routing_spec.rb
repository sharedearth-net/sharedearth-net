require "spec_helper"

describe PeopleNetworkController do
  describe "routing" do

    it "recognizes and generates #create" do
      { :post => "/people_network_requests" }.should route_to(:controller => "people_network_requests", :action => "create")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/people_network_requests/1" }.should route_to(:controller => "people_network_requests", :action => "destroy", :id => "1")
    end

  end
end
