Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
end

#API key originally had was HOPTOAD_API_KEY. HOPTOAD is the old version of AIRBRAKE?
