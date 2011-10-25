class UserMailer < ActionMailer::Base

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

end
