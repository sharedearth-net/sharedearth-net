class TermsController < ApplicationController
  def index
  end

  def accept
    current_user.person.accept!
  end
  
  def decline
    redirect_to signout_path
  end

end
