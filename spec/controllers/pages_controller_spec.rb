require 'spec_helper'

describe PagesController do

  let(:mock_item_request) { mock_model(ItemRequest).as_null_object }
  let(:mock_person) { mock_model(Person).as_null_object }
  let(:signedin_user) { generate_mock_user_with_person }

  it_should_require_signed_in_user_for_actions :dashboard

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
      response.should render_template("pages/index")
    end
  end

  describe "as signed in user" do

    before do
      signedin_user.stub(:person).and_return(mock_person)
      sign_in_as_user(signedin_user)
    end

    describe "GET 'dashboard'" do

      it "should be successful" do
        get :dashboard
        response.should be_success
        response.should render_template("pages/dashboard")
      end
      
      it "assigns the current person's requests as @item_requests" do
        mock_item_requests = [mock_model(Item), mock_model(Item)]
        signedin_user.stub(:person).and_return(mock_model(Person))
        signedin_user.person.stub(:all_item_requests) { mock_item_requests }
        get :dashboard
        assigns(:all_item_requests).should eq(mock_item_requests)
      end

    end

  end

end
