require 'spec_helper'

describe ItemRequestsController do

  let(:mock_item_request) { mock_model(ItemRequest).as_null_object }
  let(:signedin_user) { generate_mock_user_with_person }

  it_should_require_signed_in_user_for_actions :show, :new, :create, :update

  describe "as signed in user" do
    before do
      sign_in_as_user(signedin_user)
    end

    describe "GET new" do
      it "assigns a new item request as @item_request" do
        ItemRequest.stub(:new) { mock_item_request }
        get :new
        assigns(:item_request).should be(mock_item_request)
      end

      it "should render the 'new' template" do
        ItemRequest.stub(:new) { mock_item_request }
        get :new
        response.should render_template("new")
      end
    end
  end

end
