class UserMailer < ActionMailer::Base
  helper :pages
  default :from => "\"sharedearth.net\" <noreply@sharedearth.net>"

  def invitation_confirmation(user, code)
    @user = user
    attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "#{user.name} <#{user.email}>", :subject => "sharedearth.net Registration")
  end

  def invite_email(email, code)
    @invitation_code = code
    mail(:to => "#{email}", :subject => "Your sharedearth.net invitation")
  end

  def notify_with_recent_activity(recent_activity_logs, email, current_user)
    @recent_activity_logs = recent_activity_logs
    @current_user = current_user
    @time = @current_user.last_activity?
    mail(:to => "#{email}", :subject => "Recent Activity on sharedearth.net since #{ @time.strftime("#{@time.day.ordinalize} %B %Y") }")
  end

end
