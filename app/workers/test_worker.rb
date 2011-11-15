class TestWorker < SimpleWorker::Base

  def run
    log 'running notifications...'
    Cron.recent_activity
  end

end
