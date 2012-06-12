require 'spec_helper'

describe ItemsController do

  let(:signedin_user) { generate_mock_user_with_person }
  let(:nonsignedin_user) { generate_mock_user_with_person }
  let(:mock_items)    { [ mock_model(Item, :name => "Item1", :owner => signedin_user.person).
                        as_null_object, mock_model(Item, :name => "Item2").as_null_object ] }
  let(:item_one) {mock_model(Item)}
  let(:item_two) {mock_model(Item)}
  let(:resources) { [mock_model(ResourceNetwork, :resource => item_one),mock_model(ResourceNetwork, :resource => item_two)]}
  let(:item_request) {mock_model(ItemRequest, :item => mock_item, :status =>ItemRequest::STATUS_COLLECTED)}

  it_should_require_signed_in_user_for_actions :show, :edit, :update,
                                               :destroy, :mark_as_normal,
                                               :mark_as_lost, :mark_as_damaged


  def mock_item(stubs={})
    @mock_item ||= mock_model(Item, stubs).as_null_object
  end

  it_should_require_signed_in_user_for_actions :all

  describe "for signed in member" do
    before do
      sign_in_as_user(signedin_user)
      signedin_user.person.stub(:authorised?).and_return(true)
      mock_item.stub(:active_shareage_request).and_return(item_request)
    end

    describe "GET index" do
      it "assigns only owner's items as @items" do
        signedin_user.person.stub_chain(:items, :without_deleted) { [mock_item] }
        get :index
        assigns(:items).should eq([mock_item])
      end
    end

    describe "GET show" do
      before :each do
        Item.stub(:find_by_id).with("37") { mock_item }
        mock_item.stub!(:deleted?).and_return(false)
        mock_item.stub(:hidden?).and_return(false)
        mock_item.stub_chain(:item_requests, :where, :first).and_return(item_request)
      end

      it "assigns the requested item as @item" do
        get :show, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "assigns the related item request that is in state collected" do
        get :show, :id => "37"
        assigns(:item_request).should be(item_request)
      end

      it "should allow owner to view the item" do
        mock_item.stub(:is_owner?).with(signedin_user.person).and_return(true)
        get :show, :id => "37"
        assigns(:item).should be(mock_item)
        response.should be_success
      end

      it "should allow non-owner members to view the item" do
        mock_item.stub(:is_owner?).with(signedin_user.person).and_return(false)
        get :show, :id => "37"
        assigns(:item).should be(mock_item)
        response.should be_success
      end

      context "hidden item" do
        before do
          Item.stub(:find_by_id).with("37") {mock_item}
          mock_item.stub(:hidden?).and_return(true)
          mock_item.stub(:is_owner?).with(signedin_user.person).and_return(false)
          get :show, :id => "37"
        end

        it_should_behave_like "requesting a hidden item"
      end
      
      context "item in shareage" do
        before do
          Item.stub(:find_by_id).with("37") { mock_item }
          mock_item.stub!(:deleted?).and_return(false)
          mock_item.stub(:hidden?).and_return(false)
          mock_item.stub_chain(:item_requests, :where, :first).and_return(item_request)
          mock_item.stub(:is_sharage_owner?).with(signedin_user).and_return(true)
        end

        it "should show to shareage persons" do
          get :show, :id => "37"
          assigns(:item).should be(mock_item)
          response.should be_success
        end
		
        it "should not show to non-shareage persons" do 
          mock_item.should_receive(:is_shareage_owner?).with(signedin_user.person).and_return(false)
          get :show, :id => "37"
          flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
          response.should redirect_to(root_path)
		end

      end
    end

    describe "GET new" do
      it "assigns a new item as @item" do
        Item.stub(:new) { mock_item }
        get :new
        assigns(:item).should be(mock_item)
      end

      context "When the logged user is not associated with a FB account" do
        before :each do
          controller.stub(:fb_token).and_return(nil)
        end

        it "should set the 'can_post_to_fb' flag to falsy" do
          get :new
          assigns(:can_post_to_fb).should be_nil
        end
      end

      context "When the logged user is associated with a FB account" do
        before :each do
          controller.stub(:fb_token).and_return('123')
        end

        it "should set the 'can_post_to_fb' flag to true" do
          get :new
          assigns(:can_post_to_fb).should be_true
        end
      end
    end

    describe "GET edit" do
      before :each do
        mock_item.stub!(:deleted?).and_return(false)
        Item.stub(:find_by_id).with("37") { mock_item }
      end

      it "assigns the requested item as @item" do
        get :edit, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should allow only owner edit the item" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)
        get :edit, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should deny access for non-owner members" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)
        get :edit, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      context "When the requested item is deleted" do
        before :each do
          mock_item.stub!(:deleted?).and_return(true)
          get :edit, :id => "37"
        end

        it_should_behave_like "requesting a deleted item"
      end
    end

    describe "POST create" do
      describe "with valid params" do
        before :each do
          new_rep_rating = Factory(:reputation_rating)
          signedin_user.person.should_receive(:reputation_rating).and_return(new_rep_rating)
          signedin_user.person.should_receive(:items).and_return([mock_item])
        end

        it "assigns a newly created item as @item" do
          Item.stub(:new).with({'these' => 'params'}) { mock_item(:save => true) }
          post :create, :item => {'these' => 'params'}
          assigns(:item).should be(mock_item)
        end

        it "should set owner for a newly created item" do
          Item.stub(:new) { mock_item(:save => true, :owner= => signedin_user.person) }
          mock_item.should_receive(:owner=).with(signedin_user.person) # current_user is stubbed with signedin_user
          post :create, :item => {}
        end

        it "redirects to the created item" do
          Item.stub(:new) { mock_item(:save => true) }
          post :create, :item => {}
          response.should redirect_to(item_url(mock_item))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved item as @item" do
          Item.stub(:new).with({'these' => 'params'}) { mock_item(:save => false) }
          post :create, :item => {'these' => 'params'}
          assigns(:item).should be(mock_item)
        end

        it "re-renders the 'new' template" do
          mock_item.stub(:save).and_return(false)
          post :create, :item => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      before :each do
        Item.stub(:find_by_id).with("37") { mock_item }
        mock_item.stub!(:deleted?).and_return(false)
      end

      describe "with valid params" do
        it "updates the requested item" do
          mock_item.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :item => {'these' => 'params'}
        end

        it "should allow only owner to update the item" do
          mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)
          put :update, :id => "37", :item => {'these' => 'params'}
        end

        it "should deny access for non-owner members" do
          mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)
          put :update, :id => "37", :item => {'these' => 'params'}
          flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
          response.should redirect_to(root_path)
        end

        it "assigns the requested item as @item" do
          put :update, :id => "37"
          assigns(:item).should be(mock_item)
        end

        it "redirects to the item" do
          put :update, :id => "37"
          response.should redirect_to(item_url(mock_item))
        end
      end

      describe "with invalid params" do
        before :each do
          mock_item.stub!(:update_attributes).and_return(false)
        end

        it "assigns the item as @item" do
          put :update, :id => "37"
          assigns(:item).should be(mock_item)
        end

        it "re-renders the 'edit' template" do
          put :update, :id => "37"
          response.should render_template :edit
        end
      end

      context "When the requested item is deleted" do
        before :each do
          mock_item.stub!(:deleted?).and_return(true)
          put :update, :id => "37"
        end

        it_should_behave_like "requesting a deleted item"
      end
    end

    describe "DELETE destroy" do
      before :each do
        Item.stub(:find_by_id).with("37") { mock_item }
        mock_item.stub!(:deleted?).and_return(false)
      end

      it "should set the 'deleted' flag to true on the item" do
        delete :destroy, :id => "37"
        mock_item.deleted.should be_true
      end

      it "destroys the requested item" do
        mock_item.should_receive(:delete)
        delete :destroy, :id => "37"
      end

      it "should allow only owner edit the item" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)
        delete :destroy, :id => "37"
        response.should redirect_to(items_path)
      end

      it "should deny access for non-owner members" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)
        delete :destroy, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "redirects to the items list" do
        delete :destroy, :id => "37"
        response.should redirect_to(items_url)
      end

      context "When the requested item is deleted" do
        before :each do
          mock_item.stub!(:deleted?).and_return(true)
          delete :destroy, :id => "37"
        end

        it_should_behave_like "requesting a deleted item"
      end
    end

    describe "PUT mark_as_normal" do
      before do
        Item.stub(:find_by_id).with("37") { mock_item }
        mock_item.stub!(:deleted?).and_return(false)
      end

      it "assigns the requested item as @item" do
        put :mark_as_normal, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should allow only owner edit the item" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)

        put :mark_as_normal, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should deny access for non-owner members" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)

        put :mark_as_normal, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "should change request status to 'normal'" do
        mock_item.should_receive(:normal!).once
        put :mark_as_normal, :id => "37"
      end

      context "When the requested item is deleted" do
        before :each do
          mock_item.stub!(:deleted?).and_return(true)
          put :mark_as_normal, :id => "37"
        end

        it_should_behave_like "requesting a deleted item"
      end
    end

    describe "PUT mark_as_lost" do

      before do
        Item.stub(:find_by_id).with("37") { mock_item }
        mock_item.stub!(:deleted?).and_return(false)
      end

      it "assigns the requested item as @item" do
        put :mark_as_lost, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should allow only owner edit the item" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)

        put :mark_as_lost, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should deny access for non-owner members" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)

        put :mark_as_lost, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "should change request status to 'lost'" do
        mock_item.should_receive(:lost!).once
        put :mark_as_lost, :id => "37"
      end

      context "When the requested item is deleted" do
        before :each do
          mock_item.stub!(:deleted?).and_return(true)
          put :mark_as_lost, :id => "37"
        end

        it_should_behave_like "requesting a deleted item"
      end
    end

    describe "PUT mark_as_damaged" do

      before do
        Item.stub(:find_by_id).with("37") { mock_item }
        mock_item.stub!(:deleted?).and_return(false)
      end

      it "assigns the requested item as @item" do
        put :mark_as_damaged, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should allow only owner edit the item" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)

        put :mark_as_damaged, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should deny access for non-owner members" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)

        put :mark_as_damaged, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "should change request status to 'damaged'" do
        mock_item.should_receive(:damaged!).once
        put :mark_as_damaged, :id => "37"
      end

      context "When the requested item is deleted" do
        before :each do
          mock_item.stub!(:deleted?).and_return(true)
          put :mark_as_damaged, :id => "37"
        end

        it_should_behave_like "requesting a deleted item"
      end
    end

		describe "PUT mark_as_hidden" do

      before do
        Item.stub(:find_by_id).with("37") { mock_item }
        mock_item.stub!(:hidden?).and_return(false)
      end

      it "assigns the item as @item hidden" do
        put :mark_as_hidden, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should allow only owner hidden the item" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)

        put :mark_as_hidden, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should deny access for non-owner members" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)

        put :mark_as_hidden, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "should change item status to 'hidden'" do
        mock_item.should_receive(:hidden!).once
        put :mark_as_hidden, :id => "37"
      end

    end

		describe "PUT mark_as_unhidden" do

      before do
        Item.stub(:find_by_id).with("37") { mock_item }
        mock_item.stub!(:hidden?).and_return(true)
        mock_item.stub(:available?).and_return(true)
      end

      it "assigns the item as @item unhide" do
        put :mark_as_unhidden, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should allow only owner unhide the item" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)

        put :mark_as_hidden, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should deny access for non-owner members" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)

        put :mark_as_unhidden, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "should change item status to 'hidden'" do
        mock_item.should_receive(:unhide!).once
        put :mark_as_unhidden, :id => "37"
      end

    end

    describe "share mine" do
      it "should add item successfully and redirect to edit item path for non generic items" do
        existing_item = Factory.build(:item, :name => "some name", :purpose => Item::PURPOSE_SHAREAGE)
        Item.stub(:find_by_id).with("37") { existing_item }
        Item.should_receive(:quick_add).with(existing_item.item_type, signedin_user.person, Item::PURPOSE_SHARE).and_return(item_one)
        xhr :post, :share_mine, :id => "37"
        response.should be_success
        response.body.should == {:result => 'success', :redirect => edit_item_path(item_one)}.to_json
      end

      it "should add item successfully and stay on same page for generic items" do
          existing_item = Factory.build(:item, :name => nil, :purpose => Item::PURPOSE_SHAREAGE)
          Item.stub(:find_by_id).with("37") {existing_item}
          Item.should_receive(:quick_add).with(existing_item.item_type, signedin_user.person, Item::PURPOSE_SHARE).and_return(item_one)
          xhr :post, :share_mine, :id => "37"
          response.should be_success
          response.body.should == {:result => 'success'}.to_json
      end
    end
  end

end

