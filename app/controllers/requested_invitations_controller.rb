class RequestedInvitationsController < ApplicationController
  before_filter :only_logged_and_not_authorised
  def index
  end

  def create
    request = RequestedInvitation.find_by_user_id(current_user.id)

    if request.nil?
      RequestedInvitation.create!(:user_id => current_user.id, :invitation_sent_date => Time.now)
      redirect_to root_path, :notice => I18n.t("messages.requested_invitations.at_capacity")
    else
      redirect_to root_path, :notice => I18n.t("messages.requested_invitations.already_requested")
    end
  end
  
  private
   
  def only_logged_and_not_authorised
    current_user && current_user.person.authorised? unless current_user.person.nil?
  end
  
end
