require 'spec_helper'

describe "item_requests/show.html.erb" do
  let(:signedin_user) { generate_mock_user_with_person }

  before(:each) do
    view.stub(:current_user).and_return(signedin_user)

    item = stub_model(Item,
      :item_type => "MyItemType",
      :name => "MyItemName",
      :description => "MyItemDescription",
      :owner_id => 1,
      :owner_type => "Owner Type"
    )
    
    requester = mock_model(Person,
      :name => "Joe Requester"
    ).as_null_object

    gifter = mock_model(Person,
      :name => "Jane Gifter"
    ).as_null_object

    @item_request = assign(:item_request, stub_model(ItemRequest,
      :requester_id => requester.id,
      :requester_type => "Person",
      :requester => requester,
      :gifter_id => gifter.id,
      :gifter_type => "Person",
      :gifter => gifter, 
      :item_id => item.id,
      :item => item,
      :description => "MyRequestDescription",
      :status => ItemRequest::STATUS_REQUESTED
    ))
  end

  it "renders attributes" do
    render
    rendered.should contain(/#{@item_request.item.name}/)
    rendered.should contain(/#{@item_request.gifter.name}/)
    rendered.should contain(/#{@item_request.requester.name}/)
    rendered.should contain(/#{@item_request.description}/)
    rendered.should contain(/#{@item_request.status_name}/)
  end

  it "renders accept/reject buttons for gifter if request hasn't been responded to" do
    signedin_user.stub(:person).and_return(@item_request.gifter)
    @item_request.stub(:status).and_return(ItemRequest::STATUS_REQUESTED)
    render
    rendered.should have_selector("a#accept_button", :href => accept_request_path(@item_request))
    rendered.should have_selector("a#reject_button", :href => reject_request_path(@item_request))
    rendered.should_not have_selector("a#complete_button")
  end
  
  it "renders complete button for gifter if request is accepted" do
    signedin_user.stub(:person).and_return(@item_request.gifter)
    @item_request.stub(:status).and_return(ItemRequest::STATUS_ACCEPTED)
    render
    rendered.should_not have_selector("a#accept_button")
    rendered.should_not have_selector("a#reject_button")
    rendered.should have_selector("a#complete_button", :href => complete_request_path(@item_request))
  end
  
  it "doesn't render of any of the buttons (accept, reject, complete) to requester if status is 'requested'" do
    signedin_user.stub(:person).and_return(@item_request.requester)
    @item_request.stub(:status).and_return(ItemRequest::STATUS_REQUESTED)
    render
    rendered.should_not have_selector("a#accept_button")
    rendered.should_not have_selector("a#reject_button")
    rendered.should_not have_selector("a#complete_button")
  end

  it "doesn't render of any of the buttons (accept, reject, complete) to requester if status is 'accepted'" do
    signedin_user.stub(:person).and_return(@item_request.requester)
    @item_request.stub(:status).and_return(ItemRequest::STATUS_ACCEPTED)
    render
    rendered.should_not have_selector("a#accept_button")
    rendered.should_not have_selector("a#reject_button")
    rendered.should_not have_selector("a#complete_button")
  end

  it "doesn't render of any of the buttons (accept, reject, complete) to anyone if status is 'completed'" do
    signedin_user.stub(:person).and_return(@item_request.gifter)
    @item_request.stub(:status).and_return(ItemRequest::STATUS_COMPLETED)
    render
    rendered.should_not have_selector("a#accept_button")
    rendered.should_not have_selector("a#reject_button")
    rendered.should_not have_selector("a#complete_button")
  end

end
