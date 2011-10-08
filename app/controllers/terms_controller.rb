class TermsController < ApplicationController
  layout :dynamic_layout

  def index
  end
  
  def principles
  end

  def accept_tc
    current_user.person.accept_tc!
    redirect_to next_policy_path
  end
  
  def accept_pp
    current_user.person.accept_pp!
    msg  = "has connected to sharedearth.net."
    link = "http://sharedearth.net"

    FbService.post_on_my_wall(current_user.token, msg, link, :append_name => true)
    redirect_to next_policy_path
  end
    
  def dynamic_layout
    if current_user.nil?
      'shared_earth'
    else
      'application'
    end
  end

end
