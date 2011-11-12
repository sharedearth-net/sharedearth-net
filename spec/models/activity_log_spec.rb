require 'spec_helper'

describe ActivityLog do
   it { should have_db_column(:email_notification_id).of_type(:integer) }
   it { should have_db_column(:read).of_type(:boolean) }
   describe "#email_not_sent scope" do
     before do
       activity_email_not_sent = Factory(:activity_log)
       activity_email_sent = Factory(:activity_log, :email_notification_id => 1)
     end
     it "should return only activity where email is not sent" do
       activities_not_sent = ActivityLog.email_not_sent
       activities_not_sent.should be{[activity_email_not_sent]}
     end

     it "should not return activity where email is sent" do
       activities_not_sent = ActivityLog.email_not_sent
       activities_not_sent.should_not include{activity_email_sent}
     end
   end

   describe "#unread scope" do
     before do
       unread = Factory(:activity_log, :read => false)
       read = Factory(:activity_log, :read => true)
     end
     it "should return only activity where email is not sent" do
       read = ActivityLog.unread
       read.should be{[unread]}
     end

     it "should not return activity where email is sent" do
       read = ActivityLog.unread
       read.should_not include{read}
     end
   end
end
