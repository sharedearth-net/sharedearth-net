require 'spec_helper'

describe "pages/index.html.erb" do

  it "should have a link for signin with Facebook if not already signed in" do
    assign(:current_user, nil)
    render :template => "pages/index", :layout => "layouts/application"
    rendered.should have_selector("a", :href => signin_path(:provider => 'facebook'))
  end

end
