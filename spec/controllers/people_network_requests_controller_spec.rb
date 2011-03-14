require 'spec_helper'

describe PeopleNetworkRequestsController do

  let(:signedin_user) { generate_mock_user_with_person }
  let(:mock_person)   { mock_model(Person).as_null_object }

  it_should_require_signed_in_user_for_actions :all

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
        mock_person.stub(:belongs_to?).and_return(true)
        Person.stub(:find).with("37") { mock_person }
      end
    
      it "cancels trusted relationship request" do
        mock_person.should_receive(:cancel_request_trusted_relationship).with(signedin_user.person)
        delete :destroy, :id => "37"
      end
      
      it "assigns the requested person as @trusted_person" do
        mock_person.stub(:update_attributes).and_return(true)
        delete :destroy, :id => "37"
        assigns(:trusted_person).should be(mock_person)
      end
    
      it "redirects to the person page (profile)" do
        mock_person.stub(:cancel_request_trusted_relationship).and_return(true)
        delete :destroy, :id => "37"
        response.should redirect_to(person_path(mock_person))
      end
    
    end


  end
end
