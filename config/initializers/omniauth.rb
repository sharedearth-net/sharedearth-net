Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '101448083266993', 'e6fd636f8f479f62f9e62ce76d9bd8f9', {:scope => 'publish_stream,email', :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}
end
if Rails.env.development?
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE 
end
