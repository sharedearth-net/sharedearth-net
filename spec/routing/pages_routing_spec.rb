require "spec_helper"

describe PagesController do
  describe "routing" do

    it "recognizes and generates #index as root url" do
      { :get => "/" }.should route_to(:controller => "pages", :action => "index")
    end

  end
end
