require 'spec_helper'

describe VillagesController do

  let(:signedin_user) { generate_mock_user_with_person }
  let(:mock_villages)    { [ mock_model(Village, :name => "Village1").as_null_object, mock_model(Village, :name => "Village2").as_null_object ] }
  let(:village_one) {mock_model(Village)}
  let(:village_two) {mock_model(Village)}


  it_should_require_signed_in_user_for_actions :show, :edit, :update,
                                               :destroy


  def mock_village(stubs={})
    @mock_village ||= mock_model(Village, stubs).as_null_object
  end

  it_should_require_signed_in_user_for_actions :all

  describe "for signed in member" do
    before do
      sign_in_as_user(signedin_user)
      signedin_user.person.stub(:authorised?).and_return(true)
    end

    describe "GET index" do
      it "assigns only owner's villages as @villages" do
        signedin_user.person.stub_chain(:villages) { [mock_village] }
        get :index
        assigns(:villages).should eq([mock_village])
      end
    end

    describe "GET show" do
      before :each do
        Village.stub(:find_by_id).with("37") { mock_village }
      end

      it "assigns the requested village as @village" do
        get :show, :id => "37"
        assigns(:village).should be(mock_village)
      end

      it "should allow owner to view the village" do
        mock_village.stub(:is_owner?).with(signedin_user.person).and_return(true)
        get :show, :id => "37"
        assigns(:village).should be(mock_village)
        response.should be_success
      end

      it "should allow non-owner members to view the village" do
        mock_village.stub(:is_owner?).with(signedin_user.person).and_return(false)
        get :show, :id => "37"
        assigns(:village).should be(mock_village)
        response.should be_success
      end


    end

    describe "GET new" do
      it "assigns a new village as @village" do
        Village.stub(:new) { mock_village }
        get :new
        assigns(:village).should be(mock_village)
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
        mock_village.stub!(:deleted?).and_return(false)
        Village.stub(:find_by_id).with("37") { mock_village }
      end

      it "assigns the requested village as @village" do
        get :edit, :id => "37"
        assigns(:village).should be(mock_village)
      end

      it "should allow only owner edit the village" do
        mock_village.should_receive(:is_owner?).with(signedin_user.person).and_return(true)
        get :edit, :id => "37"
        assigns(:village).should be(mock_village)
      end

      it "should deny access for non-owner members" do
        mock_village.should_receive(:is_owner?).with(signedin_user.person).and_return(false)
        get :edit, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end


    end

    describe "POST create" do
      describe "with valid params" do
        before :each do
        end

        it "assigns a newly created village as @village" do
          Village.stub(:new).with({'these' => 'params'}) { mock_village(:save => true) }
          post :create, :village => {'these' => 'params'}
          assigns(:village).should be(mock_village)
        end

        it "should set owner for a newly created village" do
          Village.stub(:new) { mock_village(:save => true, :owner= => signedin_user.person) }
          mock_village.should_receive(:owner=).with(signedin_user.person) # current_user is stubbed with signedin_user
          post :create, :village => {}
        end

        it "redirects to the created village" do
          Village.stub(:new) { mock_village(:save => true) }
          post :create, :village => {}
          response.should redirect_to(village_url(mock_village))
        end

        it "adds current person as group admin to human network" do
          Village.stub(:new) { mock_village(:save=>true)}
          mock_village.should_receive(:add_admin!).with(signedin_user.person)
          post :create, :village => {}
        end

        it "adds current person's items resource network" do
          Village.stub(:new) { mock_village(:save=>true)}
          mock_village.should_receive(:add_items!).with(signedin_user.person)
          post :create, :village => {}
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved village as @village" do
          Village.stub(:new).with({'these' => 'params'}) { mock_village(:save => false) }
          post :create, :village => {'these' => 'params'}
          assigns(:village).should be(mock_village)
        end

        it "re-renders the 'new' template" do
          Village.stub(:new) { mock_village(:save => false) }
          post :create, :village => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      before :each do
        Village.stub(:find_by_id).with("37") { mock_village }
      end

      describe "with valid params" do
        it "updates the requested village" do
          mock_village.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :village => {'these' => 'params'}
        end

        it "should allow only owner to update the village" do
          mock_village.should_receive(:is_owner?).with(signedin_user.person).and_return(true)
          put :update, :id => "37", :village => {'these' => 'params'}
        end

        it "should deny access for non-owner members" do
          mock_village.should_receive(:is_owner?).with(signedin_user.person).and_return(false)
          put :update, :id => "37", :village => {'these' => 'params'}
          flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
          response.should redirect_to(root_path)
        end

        it "assigns the requested village as @village" do
          put :update, :id => "37"
          assigns(:village).should be(mock_village)
        end

        it "redirects to the village" do
          put :update, :id => "37"
          response.should redirect_to(village_url(mock_village))
        end
      end

      describe "with invalid params" do
        before :each do
          mock_village.stub!(:update_attributes).and_return(false)
        end

        it "assigns the village as @village" do
          put :update, :id => "37"
          assigns(:village).should be(mock_village)
        end

        it "re-renders the 'edit' template" do
          put :update, :id => "37"
          response.should render_template :edit
        end
      end


    end

    describe "DELETE destroy" do
      before :each do
        Village.stub(:find_by_id).with("37") { mock_village }
        mock_village.stub!(:deleted?).and_return(false)
      end

      it "should set the 'deleted' flag to true on the village" do
        delete :destroy, :id => "37"
        mock_village.deleted.should be_true
      end

      it "destroys the requested village" do
        mock_village.should_receive(:delete)
        delete :destroy, :id => "37"
      end

      it "should allow only owner edit the village" do
        mock_village.should_receive(:is_owner?).with(signedin_user.person).and_return(true)
        delete :destroy, :id => "37"
        response.should redirect_to(villages_path)
      end

      it "should deny access for non-owner members" do
        mock_village.should_receive(:is_owner?).with(signedin_user.person).and_return(false)
        delete :destroy, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_owner_can_access'))
        response.should redirect_to(root_path)
      end

      it "redirects to the villages list" do
        delete :destroy, :id => "37"
        response.should redirect_to(villages_url)
      end


    end

    describe "PUT leave" do
      before :each do
        Village.stub(:find_by_id).with("37") { mock_village }
      end

        it "calles leave method" do
          mock_village.should_receive(:leave!).with(signedin_user.person)
          put :leave, :id => "37"
        end
    end

  end

end

