require 'spec_helper'

describe ItemRequestsController do

  let(:mock_item_request) { mock_model(ItemRequest).as_null_object }
  let(:mock_item) { mock_model(Item).as_null_object }
  let(:signedin_user) { generate_mock_user_with_person }

  it_should_require_signed_in_user_for_actions :show, :new, :create, :update

  describe "as signed in user" do

    before do
      sign_in_as_user(signedin_user)
    end

    describe "GET new" do

      before do
        Item.stub(:find).with("42").and_return(mock_item)
      end
      
      it "assigns a new item request as @item_request" do
        ItemRequest.stub(:new) { mock_item_request }
        get :new, :item_id => "42"
        assigns(:item_request).should be(mock_item_request)
      end
      
      it "should set item association for new item request" do
        ItemRequest.should_receive(:new).with(:item => mock_item)
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

    end

    describe "POST create" do
      describe "with valid params" do
        # it "assigns a newly created item request as @item_request" do
        #   mock_item_request.stub(:save).and_return(true)
        #   ItemRequest.stub(:new).with({'these' => 'params'}) { mock_item_request }
        #   post :create, :item_request => {'these' => 'params'}
        #   assigns(:item_request).should be(mock_item_request)
        # end
                
        # it "should set owner for a newly created item" do
        #   Item.stub(:new) { mock_item(:save => true, :owner= => signedin_user.person) }
        #   mock_item.should_receive(:owner=).with(signedin_user.person) # current_user is stubbed with signedin_user
        #   post :create, :item => {}
        # end
        
        # it "redirects to the created item" do
        #   Item.stub(:new) { mock_item(:save => true) }
        #   post :create, :item => {}
        #   response.should redirect_to(item_url(mock_item))
        # end
      end

      # describe "with invalid params" do
      #   it "assigns a newly created but unsaved item as @item" do
      #     Item.stub(:new).with({'these' => 'params'}) { mock_item(:save => false) }
      #     post :create, :item => {'these' => 'params'}
      #     assigns(:item).should be(mock_item)
      #   end
      # 
      #   it "re-renders the 'new' template" do
      #     Item.stub(:new) { mock_item(:save => false) }
      #     post :create, :item => {}
      #     response.should render_template("new")
      #   end
      # end
    end

  end

end
