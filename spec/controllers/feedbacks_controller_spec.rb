require 'spec_helper'

describe FeedbacksController do
  let(:mock_feedback)   {  mock_model(Feedback).as_null_object}

  it "new action should render new template" do
    Feedback.stub(:new) {mock_feedback }
    get :new, :request_id => 1
    #TODO: response.should be_success
  end

  it "create action should render new template when model is invalid" do
    Feedback.stub(:new) {mock_feedback }
    post :create, :request_id => 1
    #TODO: response.should be_success
  end

  it "create action should redirect when model is valid" do
    mock_feedback.stub!(:save).and_return(true)
    post :create, :request_id => 1
    response.should redirect_to(root_path)
  end
end
