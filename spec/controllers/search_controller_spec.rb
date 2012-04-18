require 'spec_helper'

describe SearchController do
  let(:mock_user) { mock_model(User) }

  let(:mock_person) { mock_model(Person) }

  describe "GET 'index'" do
    before do
      controller.stub!(:current_user).and_return(mock_user)
      mock_user.stub(:person).and_return(mock_person)
    end

    pending "Add examples for search functionality"
    it "should be successful" do
      #get :index, :search => "Something"
      #response.should be_success
    end
  end

end
