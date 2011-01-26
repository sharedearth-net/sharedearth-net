require 'spec_helper'

describe "people/show.html.erb" do

  let(:mock_person) { stub_model(Person,
        :name => "Slobodan Kovacevic",
        :user_id => 1
  ) }
  let(:mock_user) { generate_mock_user_with_person }
  
  before do
    mock_person.stub(:user).and_return(mock_user)
    view.stub(:current_user).and_return(mock_user)
    assign(:person, mock_person)
  end

  it "renders person name" do
    render
    rendered.should match(/#{mock_person.name}/)
  end
  
  it "renders person avatar" do
    render
    rendered.should match(/#{mock_person.user.avatar}/)    
  end
  
  it "renders a link to edit profile only if showing currently signed in user" do
    render
    rendered.should have_selector("a", :href => edit_person_path(mock_person))
  end
  
  it "shouldn't render a link to edit profile if viewing someone else's profile" do
    some_other_user = mock_model(User)
    some_other_user.stub(:person)
    view.stub(:current_user).and_return(some_other_user)
    render
    rendered.should_not have_selector("a", :href => edit_person_path(mock_person))
  end
end
