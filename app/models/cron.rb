class Cron

  def self.recent_activity
    unactive_user_ids = User.unactive.collect(&:id)
    @persons = Person.notification_candidate.with_smart_notifications#.include_users(unactive_user_ids)
    @persons.each do |p| 
      @recent_activity_logs = ActivityLog.include_person(p).unread#.email_not_sent
      unless @recent_activity_logs.nil? || @recent_activity_logs.empty?
				begin
		      UserMailer.notify_with_recent_activity(@recent_activity_logs, p.email, p.user).deliver
		      email_notification = EmailNotification.create!(:person_id => p.id, :email => p.email)
		      #@recent_activity_logs.each { |a| a.log_notification_email!(email_notification) }
          #p.increase_email_notification_count!
          #p.log_email_notification_time!
		    rescue Exception => e
		      puts "Email sending failed to " + p.email
		    end
			end
		end
  end
end
