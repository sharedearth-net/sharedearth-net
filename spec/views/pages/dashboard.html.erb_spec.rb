require 'spec_helper'

describe "pages/dashboard.html.erb" do

  let(:signedin_user) { generate_mock_user_with_person }
  let(:current_person) { 
    mock_model(Person,
      :name => "Current Person",
      :avatar => "avatar-current.jpg"
    )
  }

  before(:each) do
    view.stub(:current_user).and_return(signedin_user)
    view.current_user.stub(:person).and_return(current_person)
    current_person.stub(:user).and_return(signedin_user)

    requester_user = mock_model(User)
    requester = mock_model(Person,
      :name => "Joe Requester",
      :avatar => "avatar1.jpg",
      :user => requester_user
    ).as_null_object

    gifter_user = mock_model(User)
    gifter = mock_model(Person,
      :name => "Jane Gifter",
      :avatar => "avatar2.jpg",
      :user => gifter_user
    ).as_null_object

    item = stub_model(Item,
      :item_type => "MyItemType",
      :name => "MyItemName",
      :description => "MyItemDescription",
      :owner_id => 1,
      :owner_type => "Owner Type"
    )

    current_person_request = stub_model(ItemRequest,
      :requester_id => current_person.id,
      :requester_type => "Person",
      :requester => current_person,
      :gifter_id => gifter.id,
      :gifter_type => "Person",
      :gifter => gifter, 
      :item_id => item.id,
      :item => item,
      :description => "CurrentPersonActsAsRequester",
      :status => ItemRequest::STATUS_REQUESTED
    )
    
    current_person_gift = stub_model(ItemRequest,
      :requester_id => requester.id,
      :requester_type => "Person",
      :requester => requester,
      :gifter_id => current_person.id,
      :gifter_type => "Person",
      :gifter => current_person, 
      :item_id => item.id,
      :item => item,
      :description => "CurrentPersonActsAsRequester",
      :status => ItemRequest::STATUS_REQUESTED
    )
    
    @all_item_requests = assign(:all_item_requests, [current_person_request, current_person_gift])
  end

  it "renders a list of requests" do
    first_request = @all_item_requests.first
    second_request = @all_item_requests.second
    
    render
    # first request
    rendered.should have_selector("a", :href => person_path(first_request.gifter))
    # rendered.should match(/#{first_request.gifter.avatar}/)
    rendered.should contain(/#{first_request.gifter.name}/)
    rendered.should have_selector("a#request_#{first_request.id}", :href => request_path(first_request))
    rendered.should contain(/#{first_request.item.name}/)
    rendered.should have_selector("a", :href => item_path(first_request.item))

    # second request
    rendered.should have_selector("a", :href => person_path(second_request.requester))
    rendered.should match(/#{second_request.requester.avatar}/)
    rendered.should contain(/#{second_request.requester.name}/)
    rendered.should have_selector("a#request_#{second_request.id}", :href => request_path(second_request))
    rendered.should contain(/#{second_request.item.name}/)
    rendered.should have_selector("a", :href => item_path(second_request.item))

  end
end
