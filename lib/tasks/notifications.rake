namespace :notify do
  task :activity => :environment do
 
  include PagesHelper
    unactive_user_ids = User.unactive.collect(&:id)
    puts "persons"
   
    @persons = Person.notification_cantidate.exclude_users(unactive_user_ids)
    @persons.each do |p| 
      @recent_activity_logs = ActivityLog.include_person(p).unread.email_not_sent
			begin
        UserMailer.notify_with_recent_activity(@recent_activity_logs, 'zoricn@gmail.com').deliver
      rescue Exception => e
        puts "Email sending failed"
      end
      
			puts p.id     
			puts @activity_logs  
		end
  end
end
