require "spec_helper"

describe PagesController do
  describe "routing" do

    it "recognizes and generates #index as root url" do
      { :get => "/" }.should route_to(:controller => "pages", :action => "index")
    end

    it "recognizes and generates #dashboard url" do
      { :get => "/dashboard" }.should route_to(:controller => "pages", :action => "dashboard")
    end

  end
end
