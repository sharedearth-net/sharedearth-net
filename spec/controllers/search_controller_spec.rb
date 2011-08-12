require 'spec_helper'

describe SearchController do

  describe "GET 'index'" do
    before do
      controller.stub!(:current_user).and_return(Factory(:person).user)
    end
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

end
