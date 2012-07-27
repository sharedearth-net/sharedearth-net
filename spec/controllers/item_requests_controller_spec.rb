require 'spec_helper'

describe ItemRequestsController do

  let(:mock_item_request) { mock_model(ItemRequest).as_null_object }
  let(:mock_item) { mock_model(Item).as_null_object }
  let(:mock_person) { mock_model(Person).as_null_object }
  let(:signedin_user) { generate_mock_user_with_person }

  it_should_require_signed_in_user_for_actions :all

  def as_the_requester
    mock_item_request.stub(:requester?).and_return(true)
    mock_item_request.stub(:gifter?).and_return(false)
  end

  def as_the_gifter
    mock_item_request.stub(:requester?).and_return(false)
    mock_item_request.stub(:gifter?).and_return(true)
  end

  def as_other_person
    mock_item_request.stub(:requester?).and_return(false)
    mock_item_request.stub(:gifter?).and_return(false)
  end

  describe 'test actions' do

      it "show action should require signed in user" do
          get :show, :id => '1'
          response.should redirect_to(root_path)
          flash[:alert].should eql(I18n.t('messages.must_be_signed_in'))
        end
  end

  describe "as signed in user" do

    before do
      sign_in_as_user(signedin_user)

      mock_item.stub(:deleted?).and_return(false)
    end

    describe "GET new" do

      before do
        Item.stub(:find).with("42").and_return(mock_item)
        Item.stub(:find_by_id).with("42").and_return(mock_item)
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
        # current_user is stubbed with signedin_user
        mock_item_request.should_receive(:requester=).with(signedin_user.person)
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

      context "When the requested item is deleted" do

        before :each do
          mock_item.stub(:deleted?).and_return(true)
          get :new, :item_id => "42"
        end

        it_should_behave_like "requesting a deleted item"
      end
    end

    describe "GET show" do

      it "assigns the requested requests as @item_request" do
        ItemRequest.stub(:find).with("42") { mock_item_request }
        get :show, :id => "42"
        assigns(:item_request).should be(mock_item_request) end
      it "should allow requester to view the request" do
        # mock_item_request.stub(:requester).and_return(signedin_user.person)
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        get :show, :id => "42"
        response.should be_success
      end

      it "should allow gifter to view the request" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        get :show, :id => "42"
        response.should be_success
      end

      it "should redirect other users trying to view the request" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }
        mock_item_request.stub(:completed?).and_return(false)

        get :show, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_and_requester_can_access'))
        response.should redirect_to(root_path)
      end

      it "should allow other users trying to view the request if request is completed" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }
        mock_item_request.stub(:completed?).and_return(true)
        get :show, :id => "42"
        response.should be_success
      end

      it "should not allow other users trying to view the request if request is  not completed" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }
        mock_item_request.stub(:completed?).and_return(false)
        get :show, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_and_requester_can_access'))
        response.should redirect_to(root_path)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        before do
          mock_item_request.stub(:save).and_return(true)
          Item.stub(:find_by_id).and_return(FactoryGirl.create(:item))
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
          Item.stub(:find_by_id).and_return(FactoryGirl.create(:item))
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

      context "When the requested item has been deleted" do

        before :each do
          Item.stub(:find).with("42").and_return(mock_item)
          mock_item.stub(:deleted?).and_return(true)
          post :create, :item_id => '42'
        end

        it_should_behave_like "requesting a deleted item"
      end
    end

    describe "PUT accept" do

      before(:each) do
        ItemRequest.stub(:find).with("42") { mock_item_request }
      end

      it "assigns the requested request as @item_request" do
        put :accept, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end

      it "should change request status to 'accepted'" do
        mock_item_request.should_receive(:accept!).once
        put :accept, :id => "42"
      end

      it "should redirect to dashboard page" do
        put :accept, :id => "42"
        flash[:notice].should eql(nil)
        response.should redirect_to(dashboard_path)
      end

      it "should allow only gifter to accept the request" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :accept, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(dashboard_path)
      end

      it "should redirect requester trying to accept the request" do
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :accept, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

      it "should redirect other users trying to accept the request" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :accept, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

    end

    describe "PUT reject" do

      before(:each) do
        ItemRequest.stub(:find).with("42") { mock_item_request }
      end

      it "assigns the requested request as @item_request" do
        put :reject, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end

      it "should change request status to 'rejected'" do
        mock_item_request.should_receive(:reject!).once
        put :reject, :id => "42"
      end

      it "should redirect to dashboard page" do
        put :reject, :id => "42"
        flash[:notice].should eql(nil)
        response.should redirect_to(dashboard_path)
      end

      it "should allow only gifter to reject the request" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :reject, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(dashboard_path)
      end

      it "should redirect requester trying to reject the request" do
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :reject, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

      it "should redirect other users trying to reject the request" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :reject, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

    end

    describe "PUT cancel" do

      before(:each) do
        ItemRequest.stub(:find).with("42") { mock_item_request }
      end

      it "assigns the requested request as @item_request" do
        put :cancel, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end

      it "should change request status to 'canceled'" do
        mock_item_request.should_receive(:cancel!).once
        put :cancel, :id => "42"
      end

      it "should redirect to dashboard page" do
        put :cancel, :id => "42"
        flash[:notice].should eql(nil)
        response.should redirect_to(dashboard_path)
      end

      it "should allow requester to cancel the request" do
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :cancel, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(dashboard_path)
      end

      it "should allow gifter to cancel the request" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :cancel, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(dashboard_path)
      end

      it "should redirect other users trying to cancel the request" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :cancel, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_and_requester_can_access'))
        response.should redirect_to(root_path)
      end

    end

    describe "PUT collected" do

      before(:each) do
        ItemRequest.stub(:find).with("42") { mock_item_request }
      end

      it "assigns the requested request as @item_request" do
        put :collected, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end

      it "should change request status to 'collected'" do
        mock_item_request.should_receive(:collected!).once
        put :collected, :id => "42"
      end

      it "should redirect to dashboard page" do
        put :collected, :id => "42"
        flash[:notice].should eql(nil)
        response.should redirect_to(dashboard_path)
      end

      it "should allow requester to mark request as collected" do
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :collected, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(dashboard_path)
      end

      it "should allow gifter to mark request as collected" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :collected, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(dashboard_path)
      end

      it "should redirect other users trying to mark request as collected" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :collected, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_and_requester_can_access'))
        response.should redirect_to(root_path)
      end

    end

    describe "PUT complete" do

      before(:each) do
        ItemRequest.stub(:find).with("42") { mock_item_request }
      end

      it "assigns the requested request as @item_request" do
        put :complete, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end

      it "should change request status to 'complete'" do
        mock_item_request.should_receive(:complete!).once
        put :complete, :id => "42"
      end

      it "should redirect to request page" do
        put :complete, :id => "42"
        flash[:notice].should eql(nil)
        response.should redirect_to(new_request_feedback_path(mock_item_request))
      end

      it "should allow requester to mark request as complete" do
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :complete, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(new_request_feedback_path(mock_item_request))
      end

      it "should allow gifter to mark request as complete" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :complete, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(new_request_feedback_path(mock_item_request))
      end

      it "should redirect other users trying to mark request as complete" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :complete, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_and_requester_can_access'))
        response.should redirect_to(root_path)
      end

    end

    describe "PUT return" do

      before(:each) do
        ItemRequest.stub(:find).with("42") { mock_item_request }
      end

      it "assigns the requested request as @item_request" do
        put :return, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end

      it "should change request status to 'return'" do
        mock_item_request.should_receive(:return!).once
        put :return, :id => "42"
      end

      it "should redirect to dashboard page" do
        put :return, :id => "42"
        flash[:notice].should eql(nil)
        response.should redirect_to(dashboard_path)
      end

      it "should allow only requester to return the request" do
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :return, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(dashboard_path)
      end

      it "should redirect gifter trying to return the request" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :return, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_requester_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

      it "should redirect other users trying to return the request" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :return, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_requester_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

    end

    describe "PUT recall" do

      before(:each) do
        ItemRequest.stub(:find).with("42") { mock_item_request }
      end

      it "assigns the requested request as @item_request" do
        put :recall, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end

      it "should change request status to 'recall'" do
        mock_item_request.should_receive(:recall!).once
        put :recall, :id => "42"
      end

      it "should redirect to dashboard page" do
        put :recall, :id => "42"
        flash[:notice].should eql(nil)
        response.should redirect_to(dashboard_path)
      end

      it "should allow only gifter to recall the request" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :recall, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(dashboard_path)
      end

      it "should redirect requester trying to recall the request" do
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :recall, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

      it "should redirect other users trying to recall the request" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :recall, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

    end

    describe "PUT cancel_return" do

      before(:each) do
        ItemRequest.stub(:find).with("42") { mock_item_request }
      end

      it "assigns the requested request as @item_request" do
        put :cancel_return, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end

      it "should change request status to 'cancel_return'" do
        mock_item_request.should_receive(:cancel_return!).once
        put :cancel_return, :id => "42"
      end

      it "should redirect to dashboard page" do
        put :cancel_return, :id => "42"
        flash[:notice].should eql(nil)
        response.should redirect_to(dashboard_path)
      end

      it "should allow only requester to cancel return the request" do
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :cancel_return, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(dashboard_path)
      end

      it "should redirect gifter trying to cancel return the request" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :cancel_return, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_requester_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

      it "should redirect other users trying to cancel return the request" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :cancel_return, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_requester_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

    end

    describe "PUT cancel_recall" do

      before(:each) do
        ItemRequest.stub(:find).with("42") { mock_item_request }
      end

      it "assigns the requested request as @item_request" do
        put :cancel_recall, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end

      it "should change request status to 'cancel_recall'" do
        mock_item_request.should_receive(:cancel_recall!).once
        put :cancel_recall, :id => "42"
      end

      it "should redirect to dashboard page" do
        put :cancel_recall, :id => "42"
        flash[:notice].should eql(nil)
        response.should redirect_to(dashboard_path)
      end

      it "should allow only gifter to cancel recall the request" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :cancel_recall, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(dashboard_path)
      end

      it "should redirect requester trying to cancel recall the request" do
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :cancel_recall, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

      it "should redirect other users trying to cancel recall the request" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :cancel_recall, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_can_access'))
        response.should redirect_to(request_url(mock_item_request))
      end

    end

    describe "PUT acknowledge" do

      before(:each) do
        ItemRequest.stub(:find).with("42") { mock_item_request }
      end

      it "assigns the requested request as @item_request" do
        put :acknowledge, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end

      it "should change request status to 'acknowledge'" do
        mock_item_request.should_receive(:acknowledge!).once
        put :acknowledge, :id => "42"
      end

      it "should redirect to dashboard page" do
        put :acknowledge, :id => "42"
        flash[:notice].should eql(nil)
        response.should redirect_to(dashboard_path)
      end

      it "should allow only gifter to acknowledge the request" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :acknowledge, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(dashboard_path)
      end

      it "should redirect requester trying to acknowledge the request" do
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :acknowledge, :id => "42"
        flash[:alert].should be_blank
        response.should redirect_to(dashboard_path)
      end

      it "should redirect other users trying to acknowledge the request" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :acknowledge, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_and_requester_can_access'))
        response.should redirect_to(root_url)
      end

    end

    describe "PUT returned" do

      before(:each) do
        ItemRequest.stub(:find).with("42") { mock_item_request }
      end

      it "assigns the requested request as @item_request" do
        put :returned, :id => "42"
        assigns(:item_request).should be(mock_item_request)
      end

      it "should change request status to 'return'" do
        mock_item_request.should_receive(:returned!).once
        put :returned, :id => "42"
      end

      it "should redirect to dashboard page" do
        put :returned, :id => "42"
        flash[:notice].should eql(nil)
        response.should redirect_to(new_request_feedback_path(mock_item_request))
      end

      it "should allow only requester to return the request" do
        as_the_requester
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :returned, :id => "42"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(new_request_feedback_path(mock_item_request))
      end

      it "should allow gifter mark as returned the request" do
        as_the_gifter
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :returned, :id => "42"
        flash[:alert].should be_blank
        response.should redirect_to(new_request_feedback_path(mock_item_request))
      end

      it "should redirect other users trying to return the request" do
        as_other_person
        ItemRequest.stub(:find).with("42") { mock_item_request }

        put :returned, :id => "42"
        flash[:alert].should eql(I18n.t('messages.only_gifter_and_requester_can_access'))
        response.should redirect_to(root_path)
      end

    end

  end

end
