namespace :notify do
  task :activity => :environment do
 
  include PagesHelper
    unactive_user_ids = User.unactive.collect(&:id)
    @persons = Person.notification_cantidate.include_users(unactive_user_ids)
    @persons.each do |p| 
      @recent_activity_logs = ActivityLog.include_person(p).unread.email_not_sent
			begin
        UserMailer.notify_with_recent_activity(@recent_activity_logs, 'zoricn@gmail.com', p.user).deliver
      rescue Exception => e
        puts "Email sending failed"
      end
		end
  end
end
