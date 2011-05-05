require File.dirname(__FILE__) + '/../spec_helper'

describe FeedbacksController do
  fixtures :all
  render_views

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Feedback.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Feedback.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(root_url)
  end

  it "edit action should render edit template" do
    get :edit, :id => Feedback.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Feedback.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Feedback.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Feedback.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Feedback.first
    response.should redirect_to(root_url)
  end
end
