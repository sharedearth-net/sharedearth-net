require 'spec_helper'

describe "pages/index.html.erb" do

  it "should have a link for signin with Facebook if not already signed in" do
    # view.stub!(:current_user).and_return(nil)
    view.should_receive(:current_user).and_return(nil)
    
    render :template => "pages/index", :layout => "layouts/application"
    rendered.should have_selector("a", :href => signin_path(:provider => 'facebook'))
  end
  
  it "should have a link for signout if already signed in" do
    @user = mock_model(User)
    @user.stub!(:name).and_return("Slobodan Kovacevic")
    @user.stub!(:nickname).and_return("basti")
    view.should_receive(:current_user).at_least(:once).and_return(@user)
    
    render :template => "pages/index", :layout => "layouts/application"
    rendered.should have_selector("a", :href => signout_path)
  end

end
