class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :redirect_to_back
  
  layout :dynamic_layout

  private

  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id
    # TODO: should handle unlikely case where user with that ID no longer exists
  end
  
  def authenticate_user!
    if current_user.nil? || !current_user.person.authorised? || !current_user.person.accepted?
      redirect_to root_path, :alert => I18n.t('messages.must_be_signed_in')
    end
  end
  
  # Control which layout is used.
  def dynamic_layout
    if current_user.nil?
      'welcome'
    elsif !current_user.person.authorised?
      'beta_welcome'
    else
      'application'
    end
  end
  
  #Redirection with optional notice
  def redirect_to_back(options = {}, default = dashboard_path)
    if has_referer?
      redirect_to :back, :notice => options[:notice]
    else
      redirect_to default, :notice => options[:notice]
    end
  end
  
  def has_referer?
    !request.env["HTTP_REFERER"].blank? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
  end
end
