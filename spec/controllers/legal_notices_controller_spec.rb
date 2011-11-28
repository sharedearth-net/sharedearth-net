require 'spec_helper'

describe LegalNoticesController do
  let(:signedin_user) {generate_mock_user_with_firstimer_person}
  let(:mock_person) { mock_model(Person).as_null_object}

  describe "for signed in user but not authorised" do
    before do
      sign_in_as_user(signedin_user)
      signedin_user.person.stub(:authorised?).and_return(false)
    end

    describe "GET 'index'" do

      it "should be successful" do
        get 'index'
        response.should be_success
      end
    end

    describe "PUT 'accept legal nocites'" do

      it "should redirect to principles page after accepting legal notices" do
        put :accept_legal_notice
        response.should redirect_to principles_legal_notices_path
      end
    end

    describe "GET 'principles'" do
      it "should be successful" do
        get 'principles'
        response.should be_success
      end
    end

  end
  describe "as not signed in user" do
    before do
      sign_in_as_user(signedin_user)
      signedin_user.person.stub(:authorised?).and_return(false)
    end

    describe "GET 'index'" do
      it "should be successful" do
        get 'index'
        response.should be_success
      end
    end
  end


  context "After accepting legal notices the user is visiting for the first time" do

    before(:each) do
      sign_in_as_user(signedin_user)
      signedin_user.person.stub!(:accepted_tc?).and_return(true)
      signedin_user.person.stub!(:accepted_tr?).and_return(true)
      signedin_user.person.stub!(:authorised?).and_return(true)
    end

    it "should redirect the user to its profile page" do
      put 'accept_pp'
      response.should redirect_to edit_person_path(signedin_user.person)
    end
  end
end
