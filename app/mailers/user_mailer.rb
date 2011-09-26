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

  def testing
    ses = AWS::SES::Base.new( :access_key_id     => 'AKIAJDPPPEEFNVBFDP7A', :secret_access_key => 'PVRJ8TtOwwhPjdxyOy5v/OYMxLHmz5QPRKdnLBlc' )
    ses.send_email :to        => ['zoricn@gmail.com'],
                   :source    => '"Steve Smith" <noreply@sharedearth.net>',
                   :subject   => 'Testing Amazon SES',
                   :text_body => 'Totaly original body of email'
  end
end
