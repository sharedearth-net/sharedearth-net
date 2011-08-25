class UserMailer < ActionMailer::Base

  default :from => "noreply@sharedearth.net"
  
  def invitation_confirmation(user, code)
    @user = user
    attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  end
  
  def testing
    ses = AWS::SES::Base.new( :access_key_id     => 'AKIAJDPPPEEFNVBFDP7A', :secret_access_key => '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' )
    ses.send_email :to        => ['noreply@sharedearth.net'],
                   :source    => '"Steve Smith" <noreply@sharedearth.net>',
                   :subject   => 'Testing Amazon SES',
                   :text_body => 'Totaly original body of email'
  end
end
