require 'spec_helper'

describe TermsController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "should be successful" do
      get 'principles'
      response.should be_success
    end
  end

  context "After accepting all terms and principles and the user is visiting for the first time" do
    let(:logged_person) { Factory(:person) }

    before(:each) do
      sign_in_as_user(logged_person.user)
      logged_person.stub!(:authorised?).and_return(true)
      logged_person.stub!(:accepted_tc?).and_return(true)
      logged_person.stub!(:accepted_tr?).and_return(true)
    end

    it "should redirect the user to its profile page" do
      get :accept_pp
      response.should redirect_to edit_person_path(logged_person)
    end
  end
end
