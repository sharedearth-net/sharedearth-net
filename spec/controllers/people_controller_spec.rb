require 'spec_helper'

describe PeopleController do
  
  let(:signedin_user) { generate_mock_user_with_person }
  let(:mock_person) { mock_model(Person) }
  
  it_should_require_signed_in_user_for_actions :show, :edit, :update
  
  describe "for signed in member" do
    before do
      sign_in_as_user(signedin_user)
    end

    describe "GET show" do
      it "assigns the person as @person" do
        Person.stub(:find).with("37") { mock_person }
        get :show, :id => "37"
        assigns(:person).should be(mock_person)
      end
      
      it "should render show template" do
        Person.stub(:find).with("37") { mock_person }
        get :show, :id => "37"
        response.should render_template("show")
      end
    end
  end
end
