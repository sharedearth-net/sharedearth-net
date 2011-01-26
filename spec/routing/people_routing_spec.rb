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

  end
end
