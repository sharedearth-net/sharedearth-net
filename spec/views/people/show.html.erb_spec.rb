require 'spec_helper'

describe "people/show.html.erb" do

  let(:mock_person) { stub_model(Person,
        :name => "Slobodan Kovacevic",
        :user_id => 1
  ) }
  let(:mock_user) { generate_mock_user_with_person }
  let(:mock_items){ [ stub_model(Item, :name => "Item1", :owner_id => 1, :owner_type => "Person").as_null_object, stub_model(Item, :name => "Item2", :owner_id => 1, :owner_type => "Person").as_null_object ] }
  
  before do
    @person = Factory(:person)
    @item1 = Factory(:item, :owner => @person)
    @item2 = Factory(:item, :owner => @person)
    #@item_request = Factory(:item_request, :owner => @person)
    #mock_person.stub(:user).and_return(mock_user)
    #mock_person.stub(:items).and_return(mock_items)
    @person.stub!(:trusts?).and_return(false)
    @person.user.stub!(:avatar).and_return("http://graph.facebook.com/basti/picture")
    view.stub(:current_user).and_return(@person.user)
    assign(:person, @person)
    assign(:items, @person.items)
    assign(:unanswered_requests, [])
  end
  

  it "renders person name" do
    render
    rendered.should match(/#{@person.name}/)
  end
  
  it "renders person avatar" do
    render
    rendered.should match(/#{@person.avatar}/)    
  end
  
  it "renders a link to edit profile only if showing currently signed in user" do
    render
    rendered.should have_selector("a", :href => edit_person_path(@person))
  end
  
  it "shouldn't render a link to edit profile if viewing someone else's profile" do
    some_other_person = Factory(:person, :name => "Nebojsa")
    #some_other_user = mock_model(User)
    #some_other_user.stub(:person).and_return(mock_model(Person))
    some_other_person.stub_chain(:person, :trusts?).and_return(false)
    view.stub(:current_user).and_return(some_other_person.user)
    render
    rendered.should_not have_selector("a", :href => edit_person_path(@person))
  end
  
  it "should display person's items" do
    render
    rendered.should have_selector("a", :href => item_path(@person.items.first))
    rendered.should have_selector("a", :href => item_path(@person.items.second))
  end
  
  it "should not render a link to request an item" do
    render
    rendered.should_not have_selector("a", :href => requests_path(:item_id => @person.items.first))
    rendered.should_not have_selector("a", :href => requests_path(:item_id => @person.items.second))
  end
  
  it "should render a link to request an item" do
    some_other_person = Factory(:person, :name => "Nebojsa")
    view.stub!(:current_user).and_return(some_other_person.user)
    render
    rendered.should have_selector("a", :href => requests_path(:item_id => @person.items.first))
    rendered.should have_selector("a", :href => requests_path(:item_id => @person.items.second))
  end
  
  pending "should test Trust Profile request links"
end
