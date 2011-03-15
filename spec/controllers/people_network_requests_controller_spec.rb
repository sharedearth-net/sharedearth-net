require 'spec_helper'

describe PeopleNetworkRequestsController do

  let(:signedin_user) { generate_mock_user_with_person }
  let(:mock_person)   { mock_model(Person).as_null_object }
  let(:mock_people_network_request)   { mock_model(PeopleNetworkRequest).as_null_object }

  it_should_require_signed_in_user_for_actions :all

  def as_the_requester
    mock_people_network_request.stub(:requester?).and_return(true)
    mock_people_network_request.stub(:trusted_person?).and_return(false)
  end

  def as_the_trusted_person
    mock_people_network_request.stub(:requester?).and_return(false)
    mock_people_network_request.stub(:trusted_person?).and_return(true)
  end

  def as_other_person
    mock_people_network_request.stub(:requester?).and_return(false)
    mock_people_network_request.stub(:trusted_person?).and_return(false)
  end

  describe "for signed in member" do

    before do
      sign_in_as_user(signedin_user)
    end

    describe "POST create" do

      before do
        mock_person.stub(:belongs_to?).and_return(true)
        Person.stub(:find).with("37") { mock_person }
      end

      it "creates a new trusted relationship request" do
        mock_person.should_receive(:request_trusted_relationship).with(signedin_user.person)
        post :create, :trusted_person_id => "37"
      end
      
      it "assigns the requested person as @trusted_person" do
        mock_person.stub(:update_attributes).and_return(true)
        post :create, :trusted_person_id => "37"
        assigns(:trusted_person).should be(mock_person)
      end

      it "redirects to the person page (profile)" do
        mock_person.stub(:request_trusted_relationship).and_return(true)
        post :create, :trusted_person_id => "37"
        response.should redirect_to(person_path(mock_person))
      end

    end

    describe "DELETE destroy" do
    
      before do
        # mock_person.stub(:belongs_to?).and_return(true)
        mock_people_network_request.stub(:trusted_person).and_return(mock_person)
        PeopleNetworkRequest.stub(:find).with("37") { mock_people_network_request }
      end
    
      it "assigns the requested request as @person_network_request" do
        delete :destroy, :id => "37"
        assigns(:people_network_request).should be(mock_people_network_request)
      end
      
      it "cancels trusted relationship request" do
        mock_people_network_request.should_receive(:destroy)
        delete :destroy, :id => "37"
      end
      
      it "redirects to the person page (profile)" do
        mock_people_network_request.stub(:destroy).and_return(true)
        delete :destroy, :id => "37"
        response.should redirect_to(person_path(mock_person))
      end

      it "should allow requester to cancel the request" do
        as_the_requester      
        delete :destroy, :id => "37"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(person_path(mock_person))
      end

      it "should allow trusted person to cancel the request (i.e. deny request)" do
        as_the_trusted_person      
        delete :destroy, :id => "37"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(person_path(mock_person))
      end

      it "should redirect other users trying to cancel the request" do
        as_other_person
        delete :destroy, :id => "37"      
        flash[:alert].should eql(I18n.t('messages.only_requester_and_trusted_person_can_access'))
        response.should redirect_to(root_path)
      end
    
    end

    describe "PUT confirm" do
    
      before(:each) do
        mock_people_network_request.stub(:trusted_person).and_return(mock_person)
        PeopleNetworkRequest.stub(:find).with("37") { mock_people_network_request }
      end

      it "assigns the requested request as @item_request" do
        put :confirm, :id => "37"
        assigns(:people_network_request).should be(mock_people_network_request)
      end
      
      it "should confirm trust request" do
        mock_people_network_request.should_receive(:confirm!).once
        put :confirm, :id => "37"
      end

      it "should redirect to profile page" do
        put :confirm, :id => "37"
        flash[:notice].should eql(I18n.t('messages.people_network_request.request_confirmed'))
        response.should redirect_to(person_path(mock_person))
      end

      it "should allow only trusted person to accept the request" do
        as_the_trusted_person      
        put :confirm, :id => "37"
        flash[:alert].should be_blank # make sure this is not an error redirect
        response.should redirect_to(person_path(mock_person))
      end

      it "should redirect requester trying to accept the request" do
        as_the_requester
        put :confirm, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_trusted_person_can_access'))
        response.should redirect_to(person_path(mock_person))
      end

      it "should redirect other users trying to accept the request" do
        as_other_person
        put :confirm, :id => "37"
        flash[:alert].should eql(I18n.t('messages.only_trusted_person_can_access'))
        response.should redirect_to(person_path(mock_person))
      end

    end

  end
end
