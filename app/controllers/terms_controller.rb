class TermsController < ApplicationController
  layout :dynamic_layout

  def index
  end
  
  def principles
  end

  def accept_tc
    current_user.person.accept_tc!
    redirect_to principles_terms_path
  end
  
  def accept_pp
    current_user.person.accept_pp!
    redirect_to edit_person_path(current_user.person)
  end
  
    
  def dynamic_layout
    if current_user.nil?
      'shared_earth'
    else
      'application'
    end
  end

end
