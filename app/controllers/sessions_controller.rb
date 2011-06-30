class SessionsController < ApplicationController
  
  ##
  # Sample of a omniauth.auth hash:
  # --- 
  # user_info: 
  #   name: Slobodan Kovacevic
  #   urls: 
  #     Facebook: http://www.facebook.com/thebasti
  #     Website: 
  #   nickname: thebasti
  #   last_name: Kovacevic
  #   first_name: Slobodan
  # uid: "526733220"
  # credentials: 
  #   token: 101448083266993|acc663109af8b60eb8745d7f-526733220|jIO656eoA5LvVaTC49wGy-hSHrk
  # extra: 
  #   user_hash: 
  #     name: Slobodan Kovacevic
  #     location: 
  #       name: Novi Sad, Serbia
  #       id: "106342896071173"
  #     timezone: 1
  #     gender: male
  #     id: "526733220"
  #     last_name: Kovacevic
  #     updated_time: 2010-12-12T20:06:03+0000
  #     verified: true
  #     locale: en_US
  #     hometown: 
  #       name: Novi Sad, Serbia
  #       id: "106342896071173"
  #     link: http://www.facebook.com/thebasti
  #     email: basti@orangeiceberg.com
  #     first_name: Slobodan
  # provider: facebook
  ##
  def create
    auth = request.env["omniauth.auth"]
    token = auth["credentials"]["token"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    user.token = token
    user.save!
    session[:user_id] = user.id
    session[:fb_token] = auth["credentials"]["token"] if auth['provider'] == 'facebook'
    if user.person.authorised?
      if user.person.accepted?
        redirect_to dashboard_path
      else
        redirect_to terms_path
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    split_token = session[:fb_token].split("|")
    fb_api_key = split_token[0]
    fb_session_key = split_token[1]
    session[:fb_token] = nil
    session[:user_id] = nil
    redirect_to "http://www.facebook.com/logout.php?api_key=#{fb_api_key}&session_key=#{fb_session_key}&confirm=1&next=#{root_url}";
  end
end
