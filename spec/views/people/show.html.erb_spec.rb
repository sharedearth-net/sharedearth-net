require 'spec_helper'

describe "people/show.html.erb" do

  let(:mock_person) { stub_model(Person,
        :name => "Slobodan Kovacevic",
        :user_id => 1
  ) }
  let(:mock_user) { generate_mock_user_with_person }
  let(:mock_items){ [ stub_model(Item, :name => "Item1").as_null_object, stub_model(Item, :name => "Item2").as_null_object ] }
  
  before do
    mock_person.stub(:user).and_return(mock_user)
    mock_person.stub(:items).and_return(mock_items)
    mock_person.stub(:trusts?).and_return(false)
    view.stub(:current_user).and_return(mock_user)
    assign(:person, mock_person)
    assign(:items, mock_person.items)
    assign(:unanswered_requests, [])
  end

  it "renders person name" do
    render
    rendered.should match(/#{mock_person.name}/)
  end
  
  it "renders person avatar" do
    render
    rendered.should match(/#{mock_person.avatar}/)    
  end
  
  it "renders a link to edit profile only if showing currently signed in user" do
    render
    rendered.should have_selector("a", :href => edit_person_path(mock_person))
  end
  
  it "shouldn't render a link to edit profile if viewing someone else's profile" do
    some_other_user = mock_model(User)
    some_other_user.stub(:person)
    some_other_user.stub_chain(:person, :trusts?).and_return(false)
    view.stub(:current_user).and_return(some_other_user)
    render
    rendered.should_not have_selector("a", :href => edit_person_path(mock_person))
  end
  
  it "should display person's items" do
    render
    rendered.should have_selector("a", :href => item_path(mock_person.items.first))
    rendered.should have_selector("a", :href => item_path(mock_person.items.second))
  end
  
  it "should render a link to request an item" do
    render
    rendered.should have_selector("a", :href => new_request_path(:item_id => mock_person.items.first))
    rendered.should have_selector("a", :href => new_request_path(:item_id => mock_person.items.second))
  end
  
  pending "should test Trust Profile request links"
end
