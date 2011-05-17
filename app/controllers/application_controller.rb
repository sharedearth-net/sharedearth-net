class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  
  layout :dynamic_layout

  private

  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id
    # TODO: should handle unlikely case where user with that ID no longer exists
  end
  
  def authenticate_user!
    redirect_to root_path, :alert => I18n.t('messages.must_be_signed_in') unless current_user
  end
  
  # Control which layout is used.
  def dynamic_layout
    current_user.nil? ? 'welcome' : 'application'
  end
end
