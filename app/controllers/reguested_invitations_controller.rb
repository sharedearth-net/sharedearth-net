class ReguestedInvitationsController < ApplicationController
  before_filter :only_logged_and_not_authorised

  def create
    request = RequestedInvitation.find_by_user_id(current_user.id)

    if request.nil?
      RequestedInvitation.create!(:user_id => current_user.id, :invitation_sent_date => Time.now)
      redirect_to root_url, :notice => "Your request for invitation has been received"
    else
      redirect_to root_url, :notice => "Your already requested invition, we will get back to you soon."
    end
  end
  
  private
   
  def only_logged_and_not_authorised
    current_user && current_user.person.authorised?
  end
  
end
