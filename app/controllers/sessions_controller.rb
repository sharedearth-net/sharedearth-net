require 'fb_service'

class SessionsController < ApplicationController
  def create
    auth  = request.env["omniauth.auth"]
    token = auth["credentials"]["token"]
    user  = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || 
            User.create_with_omniauth(auth)
    user.token = token
    user.person.authorise! if (Settings.invitations == 'false' && user.person.has_email?)
    user.person.reset_notification_count!
    user.record_last_activity!
    user.save!

    session[:user_id]  = user.id
    session[:fb_token] = auth["credentials"]["token"] if auth['provider'] == 'facebook'

    redirect_to root_path
  end

  def destroy
    if session[:user_id].nil? || session[:fb_token].nil? 
      redirect_to root_path

    else
      current_user.record_last_activity!
      split_token = session[:fb_token].split("|")
      fb_api_key = split_token[0]
      fb_session_key = split_token[1]

      session[:fb_token] = nil
      session[:user_id] = nil
      session[:fb_drop_url] = nil
			redirect_to root_path
      #redirect_to FbService.fb_logout_url(fb_api_key, fb_session_key, root_url)  #This redirects to facebook
    end
  end
end
