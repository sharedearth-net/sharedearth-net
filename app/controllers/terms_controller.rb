class TermsController < ApplicationController
  def index
  end

  def accept
    current_user.person.accept!
  end
  
  def decline
    current_user.destroy
    redirect_to signout_path
  end

end
