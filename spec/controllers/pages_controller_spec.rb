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
      
      it "assigns the current person's active requests as @active_item_requests" do
        mock_item_requests = [mock_model(ItemRequest, :created_at => Time.now), mock_model(ItemRequest, :created_at => Time.now)]
        signedin_user.stub(:person).and_return(mock_model(Person))
        signedin_user.person.stub(:active_item_requests) { mock_item_requests }
        signedin_user.person.stub(:received_people_network_requests) { [] } # TODO
        signedin_user.person.stub(:people_network_requests) { [] } # TODO
        signedin_user.person.stub(:activity_logs) { [] } # TODO
        signedin_user.person.stub(:news_feed) { [] } # TODO
        get :dashboard
        assigns(:active_item_requests).should eq(mock_item_requests)
      end

    end

  end

end
