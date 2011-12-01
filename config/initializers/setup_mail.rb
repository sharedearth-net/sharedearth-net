ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "sharedearth.net",
  :user_name            => "myusername",
  :password             => "secret",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
