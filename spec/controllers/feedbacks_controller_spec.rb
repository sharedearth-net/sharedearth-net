require 'spec_helper'

describe FeedbacksController do
  render_views

  it "new action should render new template" do
    feedback = Factory(:feedback)
    get :new
    response.should render_template(new_request_feedback_path(feedback.item_request))
  end

  it "create action should render new template when model is invalid" do
    feedback = Factory(:feedback)
    feedback.stub!(:valid?).returns(false)
    post :create
    
    response.should render_template(new_request_feedback_path(feedback.item_request))
  end

  it "create action should redirect when model is valid" do
    Feedback.any_instance.stub!(:valid?).returns(true)
    post :create
    response.should redirect_to(dashboard_path)
  end
end
