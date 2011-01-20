require 'spec_helper'

describe "pages/index.html.erb (aka homepage)" do

  def render_index_with_layout
    render :template => "pages/index", :layout => "layouts/application"
  end

  it "should have a link for signin with Facebook if not already signed in" do
    view.should_receive(:current_user).and_return(nil)
    
    render_index_with_layout
    rendered.should have_selector("a", :href => signin_path(:provider => 'facebook'))
  end
  
  describe "for signed in member" do
    def mock_signedin_user
      @user = mock_model(User)
      @user.stub!(:name).and_return("Slobodan Kovacevic")
      @user.stub!(:nickname).and_return("basti")
      view.stub!(:current_user).and_return(@user)
    end
    
    it "should have a link for signout" do
      mock_signedin_user
      view.should_receive(:current_user).at_least(:once)

      render_index_with_layout
      rendered.should have_selector("a", :href => signout_path)
    end
    
    it "should have a link to see item list" do
      mock_signedin_user
      render_index_with_layout
      rendered.should have_selector("a", :href => items_path)
    end
  end

end
