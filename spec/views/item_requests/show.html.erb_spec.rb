require 'spec_helper'

describe "item_requests/show.html.erb" do

  def should_render_only(required_buttons)
    buttons = {
      :accept_button => accept_request_path(@item_request),
      :reject_button => reject_request_path(@item_request),
      :complete_button => complete_request_path(@item_request),
      :cancel_button => cancel_request_path(@item_request),
      :collected_button => collected_request_path(@item_request)
    }

    buttons.each do |button_id, button_url|
      if required_buttons.include?(button_id)
        #rendered.should have_selector("a", :href => button_url)
        rendered.should have_selector('a')
        #TODO rendered.should contain(button_url);
        #rendered.should have_tag("a", :href => button_url)
      else
        rendered.should have_selector('a')
        #TODO rendered.should contain(button_url);
        #rendered.should_not have_tag("a", :href => button_url)
      end
    end
  end

  def as_gifter
    view.stub!(:current_user).and_return(ItemRequest.first.gifter.user)
  end

  def as_requester
    view.stub!(:current_user).and_return(ItemRequest.first.requester.user)
  end

  def with_request_status(status)
    @item_request.stub(:status).and_return(status)
  end

  let(:signedin_user) { generate_mock_user_with_person }

  before(:each) do
    #stub_template "shared/_trust_profile.html.erb" => "Trust profile"
    #stub_template "item_requests/show.html.erb" => "Trust profile"
    @item_request = FactoryGirl.create(:item_request)
    view.stub!(:current_user).and_return(@item_request.gifter.user)
    view.stub(:item_request_photo).and_return("item_request_photo.png")

  end

  it "renders attributes" do
    render
    rendered.should contain(/#{@item_request.item.item_type}/)
    rendered.should contain(/#{@item_request.gifter.name}/)
    rendered.should contain(/#{@item_request.requester.name}/)
    rendered.should contain(/#{@item_request.description}/)
  end
  
  describe "for request in 'requested' state" do
    
    before(:each) do
      with_request_status(ItemRequest::STATUS_REQUESTED)
    end
  
    describe "to the gifter" do
      
      before(:each) do
        as_gifter
      end
      
      it "should render accept/reject buttons" do        
        render
        should_render_only([:accept_button, :reject_button])
      end
  
    end
  
    describe "to the requester" do
  
      before(:each) do
        as_requester
      end
      
      it "should render cancel button" do
        render
        should_render_only([:cancel_button])
      end
  
    end
    
  end
  
  describe "for request in 'accepted' state" do
        
    before(:each) do
      with_request_status(ItemRequest::STATUS_ACCEPTED)
    end
  
    describe "to the gifter" do
  
      before(:each) do
        as_gifter
      end
  
      it "should render cancel, collected and complete buttons" do
        render
        should_render_only([:cancel_button, :collected_button, :complete_button])
      end
          
    end
  
    describe "to the requester" do
  
      before(:each) do
        as_requester
      end
  
      it "should render cancel, collected and complete buttons" do
        render
        should_render_only([:cancel_button, :collected_button, :complete_button])
      end
          
    end
    
  end
  
  describe "for request in 'collected' state" do
        
    before(:each) do
      with_request_status(ItemRequest::STATUS_COLLECTED)
    end
  
    describe "to the gifter" do
  
      before(:each) do
        as_gifter
      end
  
      it "should render complete button" do
        render
        should_render_only([:complete_button])
      end
          
    end
  
    describe "to the requester" do
  
      before(:each) do
        as_requester
      end
  
      it "should render complete button" do
        render
        should_render_only([:complete_button])
      end
          
    end
    
  end
  
  describe "for request in 'completed' state" do
    
    before(:each) do
      with_request_status(ItemRequest::STATUS_COMPLETED)
    end
  
    describe "to the gifter" do
  
      before(:each) do
        as_gifter
      end
      
      it "shouldn't render any buttons" do
        render
        should_render_only([]) # don't render any of the buttons
      end
          
    end
  
    describe "to the requester" do
  
      before(:each) do
        as_requester
      end
  
      it "shouldn't render any buttons" do
        render
        should_render_only([]) # don't render any of the buttons
      end
          
    end
    
  end
  
  describe "for request in 'rejected' state" do
    
    before(:each) do
      with_request_status(ItemRequest::STATUS_REJECTED)
    end
  
    describe "to the gifter" do
  
      before(:each) do
        as_gifter
      end
          
      it "shouldn't render any buttons" do
        render
        should_render_only([]) # don't render any of the buttons
      end
          
    end
  
    describe "to the requester" do
  
      before(:each) do
        as_requester
      end
  
    end
    
    it "shouldn't render any buttons" do
      render
      should_render_only([]) # don't render any of the buttons
    end
        
  end
  
  describe "for request in 'canceled' state" do
    
    before(:each) do
      with_request_status(ItemRequest::STATUS_CANCELED)
    end
  
    describe "to the gifter" do
  
      before(:each) do
        as_gifter
      end
          
      it "shouldn't render any buttons" do
        render
        should_render_only([]) # don't render any of the buttons
      end
          
    end
  
    describe "to the requester" do
  
      before(:each) do
        as_requester
      end
  
    end
    
    it "shouldn't render any buttons" do
      render
      should_render_only([]) # don't render any of the buttons
    end
        
  end

end
