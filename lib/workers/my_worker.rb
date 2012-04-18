class MyWorker < SimpleWorker::Base

  attr_accessor :x

  # The run method is what SimpleWorker calls to run your worker
  def run
    puts "Hello world"
  end

end
