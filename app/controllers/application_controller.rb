class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    # TODO: should handle unlikely case where user with that ID no longer exists
  end
  
  def authenticate_user!
    redirect_to root_path, :alert => I18n.t('messages.must_be_signed_in') unless current_user
  end
end
