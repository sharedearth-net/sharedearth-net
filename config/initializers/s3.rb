require 'paperclip_wrapper'

# http://docs.heroku.com/config-vars
if Rails.env.production?
  S3_CREDENTIALS = { :access_key_id => ENV['S3_KEY'], :secret_access_key => ENV['S3_SECRET'], :bucket => "sharedearth-production"}
else
  S3_CREDENTIALS = Rails.root.join("config/s3.yml")
end
