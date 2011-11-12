SimpleWorker.configure do |config|
    config.token = ENV['SIMPLE_WORKER_TOKEN']
    config.project_id = ENV['SIMPLE_WORKER_PROJECT_ID']
    # Use the line below if you're using an ActiveRecord database
    config.database = Rails.configuration.database_configuration[Rails.env]
end
