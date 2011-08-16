class TransparencyController < ApplicationController
  layout :dynamic_layout
  
  def dynamic_layout
    if current_user.nil?
      'shared_earth'
    else
      'application'
    end
  end

  def index
  end
  
  def accept_tr
    current_user.person.accept_tr!
    redirect_to next_policy_path
  end
end
