class TransparencyController < ApplicationController
  layout :dynamic_layout
  
  def index
  end
  
  def accept_tr
    current_user.person.accept_tr!
    redirect_to next_policy_path
  end
  
  def dynamic_layout
    if current_user.nil?  || !current_user.person.authorised_account
      'welcome'
    else
      'application'
    end
  end
end
