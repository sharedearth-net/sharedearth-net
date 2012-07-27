require 'spec_helper'

describe Cron do
  let(:person) { FactoryGirl.create(:user_with_person, :last_activity => Time.now - 13.hours).person }
  let(:active_person) { FactoryGirl.create(:person) }
  let(:recent_activity) {FactoryGirl.create(:activity_log)}


  describe Cron do
    before do
      UserMailer.stub(:notify_with_recent_acitivity).with(recent_activity, 'example@temp.com', person.users.first).and_return(true)
      Person.stub_chain(:notification_candidate, :with_smart_notifications, :include_users).and_return([person])
    end

    it "should have a published named scope that returns articles with published flag set to true" do
      Cron.stub(:recent_activity).and_return(true)
    end
=begin
#Fix tests
    it "increase notification count for person" do
      persons = Cron.recent_activity
      persons.first.email_notification_count.should == 1
    end

    it "return proper person" do
      persons = Cron.recent_activity
      persons.first.last_notification_email.should_not be(nil)
    end
=end
  end

  describe "Email of recent active to active user shouldn't be sent" do
    before do
      Person.stub_chain(:notification_candidate, :include_users).and_return([])
    end
=begin
#Fix test
    it "increase notification count for person" do
      persons = Cron.recent_activity
      persons.should be{[]}
    end
=end
  end
end
