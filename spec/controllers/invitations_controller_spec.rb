require File.dirname(__FILE__) + '/../spec_helper'

describe InvitationsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Invitation.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Invitation.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Invitation.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(invitation_url(assigns[:invitation]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Invitation.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Invitation.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Invitation.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Invitation.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Invitation.first
    response.should redirect_to(invitation_url(assigns[:invitation]))
  end

  it "destroy action should destroy model and redirect to index action" do
    invitation = Invitation.first
    delete :destroy, :id => invitation
    response.should redirect_to(invitations_url)
    Invitation.exists?(invitation.id).should be_false
  end
end
