require 'spec_helper'

describe ItemRequestsController do

  let(:mock_item_request) { mock_model(ItemRequest).as_null_object }
  let(:mock_item) { mock_model(Item).as_null_object }
  let(:mock_person) { mock_model(Person).as_null_object }
  let(:signedin_user) { generate_mock_user_with_person }

  it_should_require_signed_in_user_for_actions :show, :new, :create, :update

  describe "as signed in user" do

    before do
      sign_in_as_user(signedin_user)
    end

    describe "GET new" do

      before do
        Item.stub(:find).with("42").and_return(mock_item)
        mock_item_request.stub(:requester=)
        mock_item_request.stub(:gifter=)
      end
      
      it "assigns a new item request as @item_request" do
        ItemRequest.stub(:new) { mock_item_request }
        get :new, :item_id => "42"
        assigns(:item_request).should be(mock_item_request)
      end
      
      it "should set item association for new item request" do
        ItemRequest.should_receive(:new).with(:item => mock_item).and_return(mock_item_request)
        get :new, :item_id => "42"
      end

      it "should render the 'new' template" do
        ItemRequest.stub(:new) { mock_item_request }
        get :new, :item_id => "42"
        response.should render_template("new")
      end
      
      it "assigns a requested item as @item" do
        get :new, :item_id => "42"
        assigns(:item).should be(mock_item)
      end

      it "should set requester for a newly created request" do
        ItemRequest.stub(:new) { mock_item_request }
        mock_item_request.should_receive(:requester=).with(signedin_user.person) # current_user is stubbed with signedin_user
        get :new, :item_id => "42"
      end
      
      it "should set gifter for a newly created request" do
        mock_gifter = mock_model(Person)
        mock_item.stub(:owner).and_return(mock_gifter)
        mock_item_request.stub(:item).and_return(mock_item)
        ItemRequest.stub(:new) { mock_item_request }
      
        mock_item_request.should_receive(:gifter=).with(mock_gifter)
        get :new, :item_id => "42"
      end

    end

    describe "GET show" do

      it "assigns the requested requests as @item_request" do
        ItemRequest.stub(:find).with("42") { mock_item_request }
        get :show, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end
      
      it "should allow requester to view the request" do
        mock_item_request.stub(:requester).and_return(signedin_user.person)
        ItemRequest.stub(:find).with("42") { mock_item_request }
      
        get :show, :id => "42"
        response.should be_success
      end

      it "should allow gifter to view the request" do
        mock_item_request.stub(:gifter).and_return(signedin_user.person)
        ItemRequest.stub(:find).with("42") { mock_item_request }
      
        get :show, :id => "42"
        response.should be_success
      end

      it "should redirect other users trying to view the request" do
        # mock_item_request is already null object, so gifter and requester will return nil
        ItemRequest.stub(:find).with("42") { mock_item_request }
      
        get :show, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_and_requester_can_access'))
        response.should redirect_to(root_path)
      end

      # it "should deny access for non-owner members" do
      #   mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)
      #   Item.stub(:find).with("37") { mock_item }
      # 
      #   get :show, :id => "37"
      #   flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
      #   response.should redirect_to(root_path)
      # end

    end

    describe "POST create" do

      describe "with valid params" do

        before do
          mock_item_request.stub(:save).and_return(true)
        end

        it "assigns a newly created item request as @item_request" do
          ItemRequest.stub(:new).with({'these' => 'params'}) { mock_item_request }
          post :create, :item_request => {'these' => 'params'}
          assigns(:item_request).should be(mock_item_request)
        end
        
        it "should set request status to 'requested'" do
          ItemRequest.stub(:new) { mock_item_request }          
          mock_item_request.should_receive(:status=).with(ItemRequest::STATUS_REQUESTED)
          post :create, :item => {}          
        end
                
        it "should set requester for a newly created request" do
          ItemRequest.stub(:new) { mock_item_request }
          mock_item_request.should_receive(:requester=).with(signedin_user.person) # current_user is stubbed with signedin_user
          post :create, :item => {}
        end
        
        it "should set gifter for a newly created request" do
          mock_gifter = mock_model(Person)
          mock_item.stub(:owner).and_return(mock_gifter)
          mock_item_request.stub(:item).and_return(mock_item)
          ItemRequest.stub(:new) { mock_item_request }

          mock_item_request.should_receive(:gifter=).with(mock_gifter)
          post :create, :item => {}
        end
        
        it "redirects to the created item" do
          ItemRequest.stub(:new) { mock_item_request }
          post :create, :item => {}
          response.should redirect_to(request_url(mock_item_request))
        end

      end

      describe "with invalid params" do

        before do
          mock_item_request.stub(:save).and_return(false)
        end
        
        it "assigns a newly created but unsaved request as @item_request" do
          ItemRequest.stub(:new).with({'these' => 'params'}) { mock_item_request }
          post :create, :item_request => {'these' => 'params'}
          assigns(:item_request).should be(mock_item_request)
        end
      
        it "re-renders the 'new' template" do
          ItemRequest.stub(:new) { mock_item_request }
          post :create, :item_request => {}
          response.should render_template("new")
        end

      end

    end

  end

end
