desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  include PagesHelper
  Cron.recent_activity
end
