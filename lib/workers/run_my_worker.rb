require 'simple_worker'
require_relative 'my_worker'

# Use this configure block for simple_worker gem v2.x (token/project_id)
SimpleWorker.configure do |config|     
  config.token = ENV['SIMPLE_WORKER_TOKEN']
  config.project_id = ENV['SIMPLE_WORKER_PROJECT_ID']
end

worker = MyWorker.new
worker.x = 10
worker.run_local
#worker.queue
