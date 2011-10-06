class RequestedInvitationsController < ApplicationController
  before_filter :only_logged_and_not_authorised
  def index
  end

  def give
    request = RequestedInvitation.find_by_user_id(current_user.id)

    if request.nil?
      RequestedInvitation.create!(:user_id => current_user.id, :invitation_sent_date => Time.now)
      redirect_to root_path, :notice => "Your request has been received. The site is currently at capacity. Your invite will be dispatched as soon as possible."
    else
      redirect_to root_path, :notice => "You have already requested an invitation. It will be dispatched as soon as possible."
    end
  end
  
  private
   
  def only_logged_and_not_authorised
    current_user && current_user.person.authorised? unless current_user.nil?
  end
  
end
