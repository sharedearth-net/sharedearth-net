desc "Manually run cron job for notification to all users"
task :cron => :environment do
  Cron.recent_activity
end
