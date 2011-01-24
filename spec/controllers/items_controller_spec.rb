require 'spec_helper'

describe ItemsController do
  include UserMocks
  
  let(:signedin_user) { mock_signedin_user }
  # let(:signedin_person) { mock_person_for_user(signedin_user) }

  def mock_item(stubs={})
    @mock_item ||= mock_model(Item, stubs).as_null_object
  end

  describe "for visitor" do
    it "should deny access to visitors" do
      controller.stub!(:current_user).and_return(false)

      get :index

      flash[:alert].should eql(I18n.t('messages.must_be_signed_in'))
      response.should redirect_to(root_path)
    end
  end

  describe "for signed in member" do
    before do
      controller.stub!(:current_user).and_return(signedin_user)
      controller.should_receive(:authenticate_user!)
    end

    describe "GET index" do
      it "assigns only owner's items as @items" do
        signedin_user.stub(:person)
        signedin_user.person.stub(:items) { [mock_item] }
        get :index
        assigns(:items).should eq([mock_item])
      end
    end

    describe "GET show" do
      it "assigns the requested item as @item" do
        Item.stub(:find).with("37") { mock_item }
        get :show, :id => "37"
        assigns(:item).should be(mock_item)
      end
      
      it "should allow only owner to view the item" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)
        Item.stub(:find).with("37") { mock_item }

        get :show, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should deny access for non-owner members" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)
        Item.stub(:find).with("37") { mock_item }
      
        get :show, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end
    end

    describe "GET new" do
      it "assigns a new item as @item" do
        Item.stub(:new) { mock_item }
        get :new
        assigns(:item).should be(mock_item)
      end
    end

    describe "GET edit" do
      it "assigns the requested item as @item" do
        Item.stub(:find).with("37") { mock_item }
        get :edit, :id => "37"
        assigns(:item).should be(mock_item)
      end
      
      it "should allow only owner edit the item" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)
        Item.stub(:find).with("37") { mock_item }

        get :edit, :id => "37"
        assigns(:item).should be(mock_item)
      end

      it "should deny access for non-owner members" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)
        Item.stub(:find).with("37") { mock_item }
      
        get :edit, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end
    end

    describe "POST create" do
      describe "with valid params" do
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
          Item.stub(:new) { mock_item(:save => false) }
          post :create, :item => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested item" do
          Item.stub(:find).with("37") { mock_item }
          mock_item.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :item => {'these' => 'params'}
        end
        
        it "should allow only owner to update the item" do
          mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)
          Item.stub(:find).with("37") { mock_item }

          put :update, :id => "37", :item => {'these' => 'params'}
        end

        it "should deny access for non-owner members" do
          mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)
          Item.stub(:find).with("37") { mock_item }

          put :update, :id => "37", :item => {'these' => 'params'}
          flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
          response.should redirect_to(root_path)
        end

        it "assigns the requested item as @item" do
          Item.stub(:find) { mock_item(:update_attributes => true) }
          put :update, :id => "1"
          assigns(:item).should be(mock_item)
        end

        it "redirects to the item" do
          Item.stub(:find) { mock_item(:update_attributes => true) }
          put :update, :id => "1"
          response.should redirect_to(item_url(mock_item))
        end
      end

      describe "with invalid params" do
        it "assigns the item as @item" do
          Item.stub(:find) { mock_item(:update_attributes => false) }
          put :update, :id => "1"
          assigns(:item).should be(mock_item)
        end

        it "re-renders the 'edit' template" do
          Item.stub(:find) { mock_item(:update_attributes => false) }
          put :update, :id => "1"
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested item" do
        Item.stub(:find).with("37") { mock_item }
        mock_item.should_receive(:destroy)
        delete :destroy, :id => "37"
      end
      
      it "should allow only owner edit the item" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(true)
        Item.stub(:find).with("37") { mock_item }

        delete :destroy, :id => "37"
        response.should redirect_to(items_path)
      end

      it "should deny access for non-owner members" do
        mock_item.should_receive(:is_owner?).with(signedin_user.person).and_return(false)
        Item.stub(:find).with("37") { mock_item }
      
        delete :destroy, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "redirects to the items list" do
        Item.stub(:find) { mock_item }
        delete :destroy, :id => "1"
        response.should redirect_to(items_url)
      end
    end
  end

end
