if RAILS_ENV=="production"
  Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
  config.host = 'api.airbrake.io' 
  end
end 

#API key originally had was HOPTOAD_API_KEY. HOPTOAD is the old version of AIRBRAKE?
