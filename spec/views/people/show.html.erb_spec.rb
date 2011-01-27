require 'spec_helper'

describe "people/show.html.erb" do

  let(:mock_person) { stub_model(Person,
        :name => "Slobodan Kovacevic",
        :user_id => 1
  ) }
  let(:mock_user) { generate_mock_user_with_person }
  let(:mock_items){ [ mock_model(Item, :name => "Item1").as_null_object, mock_model(Item, :name => "Item2").as_null_object ] }
  
  before do
    mock_person.stub(:user).and_return(mock_user)
    mock_person.stub(:items).and_return(mock_items)
    view.stub(:current_user).and_return(mock_user)
    assign(:person, mock_person)
    assign(:items, mock_person.items)
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
  
  it "should display person's items" do
    render
    rendered.should have_selector("a", :href => item_path(mock_person.items.first))
    rendered.should have_selector("a", :href => item_path(mock_person.items.second))
  end
end
