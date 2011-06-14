require 'spec_helper'

describe "pages/index.html.erb (aka homepage)" do

  let(:signedin_user) { generate_mock_user_with_person }

  # TODO: we probably shouldn't test the layout through index page. See how to make that separate test.
  def render_index_with_layout
    render :template => "pages/index", :layout => "layouts/application"
  end

  it "should have a link for signin with Facebook if not already signed in" do
    view.stub!(:current_user).and_return(nil)
    
    render_index_with_layout
    rendered.should have_selector("a", :href => '/auth/facebook')
  end
  
  describe "for signed in member" do

    before do
      @person = Factory(:person)
      view.should_receive(:current_user).at_least(:once).and_return(@person.user) # makes sure that we are checking current_user at least once
    end
    
    it "should have a link for signout" do
      render_index_with_layout
      rendered.should have_selector("a", :href => signout_path)
    end
    
    it "should have a link to see item list" do
      render_index_with_layout
      rendered.should have_selector("a", :href => items_path)
    end

    it "should have a link to see profile page" do
      render_index_with_layout
      rendered.should have_selector("a", :href => person_path(@person))
    end

    it "should have a link to see dashboard" do
      render_index_with_layout
      rendered.should have_selector("a", :href => dashboard_path)
    end

  end

end
