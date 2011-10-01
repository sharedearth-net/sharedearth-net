Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['SEN_FACEBOOK_APP_ID'], ENV['SEN_FACEBOOK_APP_SECRET'], {:scope => 'publish_stream,email', :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}
end
if Rails.env.development?
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE 
end
