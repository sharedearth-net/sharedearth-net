require 'spec_helper'

describe PagesController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
      response.should render_template("pages/index")
    end
  end

end

describe PagesController, "#route_for" do

  it "should map { :controller => 'pages', :action => 'index' } to /" do
    { :get => "/" }.should route_to(:controller => "pages", :action => "index")
    # route_for(:controller => "pages", :action => "index").should == "/"
  end

end