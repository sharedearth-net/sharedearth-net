Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '101448083266993', 'e6fd636f8f479f62f9e62ce76d9bd8f9'
end