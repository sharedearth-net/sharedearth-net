# for sharedearth.dev
if Rails.env == "production"
	ENV['SEN_FACEBOOK_APP_ID'] = '490958594277257'
	ENV['SEN_FACEBOOK_APP_SECRET'] = '9be92c862fff10a4fbec0e89f958e0b9'
else
	ENV['SEN_FACEBOOK_APP_ID'] = '247995528636572'
	ENV['SEN_FACEBOOK_APP_SECRET'] = 'eceff669e282d1bb7e844d780c09cfc9'
end

#ENV['SEN_GITHUB_APP_ID'] = '8e2dde623cb406befc59'
#ENV['SEN_GITHUB_APP_SECRET'] = 'c43c093c8a9bed2f48d385864d7013a9f632c592'

# for sharedearthnet.heroku.com
# google for dev server 582283019306.apps.googleusercontent.com OamMuedvLdebMZD3HKuF6CA0
# github for dev server de2009127c6ac8f70b77 c3a95f6e74dd903121213075638307cb2b24c4f2

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,         ENV['SEN_GITHUB_APP_ID'],   ENV['SEN_GITHUB_APP_SECRET'],   :scope => "user"
  provider :facebook,       ENV['SEN_FACEBOOK_APP_ID'], ENV['SEN_FACEBOOK_APP_SECRET'], {:scope => 'publish_stream,email', :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}
  provider :google_oauth2,  ENV['SEN_GOOGLE_APP_ID'],   ENV['SEN_GOOGLE_APP_SECRET'],   {access_type: 'online', approval_prompt: ''}
end

if Rails.env.development?
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE 
end
