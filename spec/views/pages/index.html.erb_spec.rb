require 'spec_helper'

describe "pages/index.html.erb (aka homepage)" do
  include UserMocks

  let(:signedin_user) { mock_signedin_user }

  def render_index_with_layout
    render :template => "pages/index", :layout => "layouts/application"
  end

  it "should have a link for signin with Facebook if not already signed in" do
    view.should_receive(:current_user).and_return(nil)
    
    render_index_with_layout
    rendered.should have_selector("a", :href => signin_path(:provider => 'facebook'))
  end
  
  describe "for signed in member" do
    before do
      # mock_signedin_user
      # view.stub!(:current_user).and_return(signedin_user)
      view.should_receive(:current_user).at_least(:once).and_return(signedin_user) # makes sure that we are checking current_user at least once
    end
    
    it "should have a link for signout" do
      render_index_with_layout
      rendered.should have_selector("a", :href => signout_path)
    end
    
    it "should have a link to see item list" do
      render_index_with_layout
      rendered.should have_selector("a", :href => items_path)
    end
  end

end
