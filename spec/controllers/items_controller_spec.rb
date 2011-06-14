require 'spec_helper'

describe ItemsController do
  
  let(:signedin_user) { Factory(:person).user }

  def mock_item(stubs={})
    @item ||= mock_model(Item, stubs).as_null_object
  end
  
  def factory_item
    @item = Factory(:item)
  end
  
  it_should_require_signed_in_user_for_actions :all

  describe "for signed in member" do
    before do
      controller.stub!(:current_user).and_return(signedin_user)
      @factory_item = Factory(:item)
    end

    describe "GET index" do
      it "assigns only owner's items as @items" do
        signedin_user.stub(:person).and_return(mock_model(Person))
        signedin_user.person.stub_chain(:items, :without_deleted) { [mock_item] }
        get :index
        assigns(:items).should eq([mock_item])
      end
    end

    describe "GET show" do

      it "assigns the requested item as @item" do
        get :show, :id => @factory_item
        assigns(:item).should == @factory_item
      end
      
      it "should allow owner to view the item" do
        @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(true)
        get :show, :id => @factory_item
        assigns(:item).should == @factory_item
        response.should be_success
      end

      it "should allow non-owner members to view the item" do
        @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(false)
        
        get :show, :id => @factory_item
        assigns(:item).should == @factory_item
        response.should be_success
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
        get :edit, :id => @factory_item
        assigns(:item).should == @factory_item
      end
      
      it "should allow only owner edit the item" do
        @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(true)

        get :edit, :id => @factory_item
        assigns(:item).should == @factory_item
      end

      it "should deny access for non-owner members" do
        @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(false)
        Item.stub(:find).with("37") { mock_item }
      
        get :edit, :id => @factory_item
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end
    end

    describe "POST create" do
      
      describe "with valid params" do
        it "assigns a newly created item as @item" do
          Item.any_instance.stub!(:valid?).and_return(true)
          post 'create'
          assigns[:item].should be_new_record
        end
                
        it "should set owner for a newly created item" do
          @factory_item.stub!(:is_owner?).and_return(signedin_user.person) # current_user is stubbed with signedin_user
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
          @factory_item.stub!(:update_attributes).with({'these' => 'params'})
          put :update, :id => @factory_item.id, :item => {'these' => 'params'}
        end
        
        it "should allow only owner to update the item" do
          @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(true)

          put :update, :id => @factory_item, :item => {'these' => 'params'}
        end

        it "should deny access for non-owner members" do
          @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(false)

          put :update, :id => @factory_item, :item => {'these' => 'params'}
          flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
          response.should redirect_to(root_path)
        end
     end

     describe "PUT update with mock item" do
        before do
          @factory_item = Factory(:item, :owner => signedin_user.person)
        end
        it "assigns the requested item as @item" do
          @factory_item.stub!(:update_attributes).and_return(true)
          put :update, :id => @factory_item
          assigns(:item).should == @factory_item
        end

        it "redirects to the item" do
          
          @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(true)
          put :update, :id => @factory_item
          response.should redirect_to(item_url(@factory_item))
        end
      end

      describe "with invalid params" do
        it "assigns the item as @item" do
          @factory_item.stub!(:update_attributes).and_return(false)
          @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(true)
          put :update, :id => @factory_item
          assigns(:item).should == @factory_item
        end

        it "re-renders the 'edit' template" do
          @factory_item = Factory(:item, :owner => signedin_user.person)
          @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(true)
          @factory_item.stub!(:update_attributes).and_return(false)
          put :update, :id => @factory_item
          response.should redirect_to(item_url(@factory_item))
        end
      end
    end

    describe "DELETE destroy" do
      
      it "destroys the requested item" do
        @factory_item.stub!(:delete)
        delete :destroy, :id => @factory_item.id
      end
      
      it "should allow only owner edit the item" do
        @factory_item = Factory(:item, :owner => signedin_user.person)
        @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(true)

        delete :destroy, :id => @factory_item.id
        response.should redirect_to(items_path)
      end

      it "should deny access for non-owner members" do
        @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(false)
      
        delete :destroy, :id => @factory_item.id
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "redirects to the items list" do
        @factory_item = Factory(:item, :owner => signedin_user.person)
        @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(true)
        delete :destroy, :id => @factory_item.id
        response.should redirect_to(items_url)
      end
    end

    describe "PUT mark_as_normal" do
  
      it "assigns the requested item as @item" do
        put :mark_as_normal, :id => @factory_item.id
        assigns(:item).should == @factory_item
      end
      
      it "should allow only owner edit the item" do
        factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(true)

        put :mark_as_normal, :id => @factory_item
        assigns(:item).should == @factory_item
      end

      it "should deny access for non-owner members" do
        factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(false)
      
        put :mark_as_normal, :id => @factory_item
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "should change request status to 'normal'" do
        factory_item.stub!(:normal!)
        put :mark_as_normal, :id => @item.id
      end

    end

    describe "PUT mark_as_lost" do
  
      it "assigns the requested item as @item" do
        put :mark_as_lost, :id => @factory_item.id
        assigns(:item).should == @factory_item
      end
      
      it "should allow only owner edit the item" do
        @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(true)

        put :mark_as_lost, :id => @factory_item.id
        assigns(:item).should == @factory_item
      end

      it "should deny access for non-owner members" do
        @factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(false)
      
        put :mark_as_lost, :id => @factory_item.id
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "should change request status to 'lost'" do
        factory_item.stub!(:lost!)
        put :mark_as_lost, :id => @item.id
      end

    end

    describe "PUT mark_as_damaged" do

  
      it "assigns the requested item as @item" do
        put :mark_as_damaged, :id => factory_item.id
        assigns(:item).should == @item
      end
      
      it "should allow only owner edit the item" do
        factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(true)

        put :mark_as_damaged, :id => @item.id
        assigns(:item).should == @item
      end

      it "should deny access for non-owner members" do
        factory_item.stub!(:is_owner?).with(signedin_user.person).and_return(false)
      
        put :mark_as_damaged, :id => @item.id
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "should change request status to 'damaged'" do
        factory_item.stub!(:damaged!)
        put :mark_as_damaged, :id => @item.id
      end

    end
  end

end
