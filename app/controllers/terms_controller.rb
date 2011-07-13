class TermsController < ApplicationController
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

end
