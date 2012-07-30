class LegalNoticesController < ApplicationController
  layout :dynamic_layout

  def index
  end

  def principles
  end

  def accept_legal_notice
    current_user.person.accept_tc!
    current_user.person.accept_tr!
    redirect_to next_policy_path
  end

  def accept_pp
    current_user.person.accept_pp!
    if !params[:facebook].nil? && !current_user.person.has_reviewed_profile? && current_user.provider == "facebook"
      msg  = "has connected to sharedearth.net."
      link = "http://sharedearth.net"

      FbService.post_on_my_wall(current_user.token, msg, link, :append_name => true)
    end
    redirect_to next_policy_path
  end

  def dynamic_layout
    if current_user.nil? || Settings.invitations != 'true' || !current_user.person.authorised_account
      'welcome'
    else
      'application'
    end
  end

end
