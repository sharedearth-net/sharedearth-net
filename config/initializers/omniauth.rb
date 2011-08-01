Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '216097298441765', 'cb27474f079a8ae3a07e592c7d8fb2e1', {:scope => 'publish_stream,email', :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}
end
if Rails.env.development?
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE 
end
