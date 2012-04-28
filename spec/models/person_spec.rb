require 'spec_helper'

describe Person do
  let(:user) { mock_model(User) }

  let(:short_name) { 'some normal name' }

  let(:long_name) { 'juan' * 20 }

  let(:long_location) { 'a' * 43 }

  let(:long_description) { 'I' * 401 }

  it { should have_db_column(:email_notification_count).of_type(:integer) }

  it { should have_db_column(:last_notification_email).of_type(:datetime) }

  it { should belong_to(:user) }

  it { should have_many(:items) }

  it { should have_many(:item_requests) }

  it { should have_many(:item_gifts) }

  it { should validate_presence_of(:user_id) }

  it { should validate_presence_of(:name) }

  it { should allow_value(short_name).for(:name) }

  it { should_not allow_value(long_name).for(:name) }

  it { should_not allow_value(long_location).for(:location) }

  it { should_not allow_value(long_description).for(:description) }

  it "should check if it belongs to user" do
    person = Person.new(:user => user)
    person.belongs_to?(user).should be_true
  end

  it "should check if it belongs to user (negative case)" do
    some_other_user = mock_model(User)
    person = Person.new(:user => user)
    person.belongs_to?(some_other_user).should be_false
  end

  it "should have a 'has_reviewed_profile' flag with false as default" do
    person = Factory(:person)
    person.has_reviewed_profile.should be_false
  end
end

describe Person, ".all_item_requests" do

  it "should return all requests for this person (both as gifter and requester)" do
    # OPTIMIZE: I don't like this test. Maybe there's better way to test this.
    person = Person.new
    first_request = mock_model(ItemRequest)
    second_request = mock_model(ItemRequest)
    ItemRequest.stub(:involves).and_return([first_request, second_request])

    person.all_item_requests.should eql([first_request, second_request])
  end

end

describe Person, ".active_item_requests" do

  it "should return active requests for this person (both as gifter and requester)" do
    # OPTIMIZE: I don't like this test. Maybe there's better way to test this.
    person = Person.new
    first_request = mock_model(ItemRequest)
    second_request = mock_model(ItemRequest)
    ItemRequest.stub_chain(:involves, :active, :order).and_return([first_request, second_request])

    person.active_item_requests.should eql([first_request, second_request])
  end

end

describe Person, ".avatar" do

  it "should return user's avatar" do
    user = mock_model(User, :avatar => "avatar1.jpg")
    person = Person.new(:user => user)
    person.avatar.should eql(user.avatar)
  end

end

describe Person, ".trusted_network_count(other_person)" do

  it "should return user's number friends of friends" do
    first_user = mock_model(User)
    second_user = mock_model(User)
    first_person = Person.new(:user => first_user)
    second_person = Person.new(:user => second_user)
    #TO DO: Finish this test, create more people, and check network count
  end

end

describe Person, ".trusts_me_count" do

  it "should return number of users who trusts current user" do
    first_user = mock_model(User)
    second_user = mock_model(User)
    first_person = Person.new(:user => first_user)
    second_person = Person.new(:user => second_user)
    #TO DO: Finish this test, create more people, and check trusts me count
  end

end

describe Person, ".request_trusted_relationship" do

  it "should create new person network request" do
    request_person = stub_model(Person, :name => "Requester")
    person         = stub_model(Person, :name => "Receiver")
    expect {
      person.request_trusted_relationship(request_person)
    }.to change { person.received_network_requests.count }.by(1)
  end


  it "should create only one person network request on mulitple request attempts" do
    requester = Factory(:person)
    requested = Factory(:person)

    expect {
      requested.request_trusted_relationship(requester)
      requested.request_trusted_relationship(requester)
    }.to change { NetworkRequest.count }.by(1)
  end
end

describe Person, ".requested_trusted_relationship?" do

  it "should return true if request for trusted relationship already exists" do
    request_person = stub_model(Person, :name => "Requester")
    person = stub_model(Person, :name => "Receiver")
    person.request_trusted_relationship(request_person)
    person.requested_trusted_relationship?(request_person).should be_true
  end

  it "should return false if request for trusted relationship doesn't exists" do
    request_person = stub_model(Person, :name => "Requester")
    person = stub_model(Person, :name => "Receiver")
    person.requested_trusted_relationship?(request_person).should be_false
  end

end

describe Person, ".first_name" do

  it "should return first name" do
    Person.new(:name => "Slobodan Kovacevic").first_name.should eql("Slobodan")
  end
end

describe Person, "When printing user trust profile" do
  it "should generate proper gift act rating" do
  #TODO
  end

  it "should generate proper number of people helped" do
  #TODO
  end

  it "should generate proper number of gift act actions" do
  #TODO
  end
end


describe Person, ".network_activity" do
  let(:person) { Factory(:person) }

  let(:maria)  { Factory(:person) }

  let(:mr_t) { Factory(:person) }

  let(:human_network) { Factory(:human_network, :entity => person, :person_id => maria.id)}

  let(:my_event_displays) do
    FactoryGirl.create_list(:event_display, 5, :person_id => person.id, :event_log_id => 1)
  end

  let(:maria_event_displays) do
    FactoryGirl.create_list(:event_display, 5, :person_id => maria.id, :event_log_id => 2)
  end

  let(:mr_t_event_displays) do
    FactoryGirl.create_list(:event_display, 5, :person_id => mr_t.id, :event_log_id => 3)
  end

  before :each do
    person.stub(:human_networks).and_return([human_network])
    person.stub!(:trusted_friends).and_return([maria])
  end

  it "should respond to 'network_activity'" do
    person.should respond_to(:network_activity)
  end

  it "should include the EventDisplays that belong to the person" do
    my_event_log_ids = my_event_displays.collect(&:event_log_id)
    my_network_activity_events_ids = person.network_activity.collect(&:event_log_id)

    my_event_log_ids.should include(*my_network_activity_events_ids)
  end

  it "should include the EventDisplays of the people on my trusted network" do
    maria_event_log_ids = maria_event_displays.collect(&:event_log_id)
    my_network_activity_events_ids = person.network_activity.collect(&:event_log_id)

    my_network_activity_events_ids.should include(*maria_event_log_ids)
  end

  it "should not include the EventDisplays of the people that aren't on my trusted network" do
    mr_t_event_log_ids = mr_t_event_displays.collect(&:event_log_id)
    my_network_activity_events_ids = person.network_activity.collect(&:event_log_id)

    my_network_activity_events_ids.should_not include(*mr_t_event_log_ids)
  end
end

describe Person, ".trusted_friends_items" do
  let(:juan) { Factory(:person) }

  let(:golbert) { Factory(:person) }

  let(:golbert_items) { FactoryGirl.create_list(:item, 5, :owner => golbert) }

  before :each do
    golbert_items[0].delete

    juan.stub!(:trusted_friends).and_return([golbert])
  end

  it "should only return the items that are not deleted" do
    juan.trusted_friends_items.size.should == 4
  end
end

describe Person, ".accepted_tc?" do
  it "should return false if the accepted_tc flag is set to false" do
    person = Factory(:person)
    person.update_attributes(:accepted_tc => false)
    person.accepted_tc?.should be_false
  end

  it "should return false if the tc_version is not the same as the one in the app" do
    person = Factory(:person)
    person.update_attributes(:accepted_tc => true, :tc_version => 1)
    TC_VERSION = 2
    person.accepted_tc?.should be_false
  end

  it "should return true otherwise" do
    person = Factory(:person)
    person.update_attributes(:accepted_tc => true, :tc_version => TC_VERSION)
    person.accepted_tc?.should be_true
  end
end

describe Person, ".accepted_tr?" do
  it "should return false if the accepted_tr flag is set to false" do
    person = Factory(:person)
    person.update_attributes(:accepted_tr => false)
    person.accepted_tr?.should be_false
  end

  it "should return true otherwise" do
    person = Factory(:person)
    person.update_attributes(:accepted_tc => true)
    person.accepted_tr?.should be_true
  end
end

describe "facebook friends" do
  it "should return facebook friends for the person" do
    person = Factory(:person)
    Factory :facebook_friend_network, :entity => person
    person.facebook_friends.count.should == 1
  end
end

describe Person, ".accepted_pp?" do
  it "should return false if the accepted_pp flag is set to false" do
    person = Factory(:person)
    person.update_attributes(:accepted_pp => false)
    person.accepted_pp?.should be_false
  end

  it "should return false if the tc_version is not the same as the one in the app" do
    person = Factory(:person)
    person.update_attributes(:accepted_pp => true, :pp_version => 1)
    PP_VERSION = 2
    person.accepted_pp?.should be_false
  end

  it "should return true otherwise" do
    person = Factory(:person)
    person.update_attributes(:accepted_pp => true, :pp_version => PP_VERSION)
    person.accepted_pp?.should be_true
  end
  describe Person do
    describe "#notification_candidate scope" do
      before :each do
        @first_person = Factory(:person, :authorised_account => false)
        @second_person = Factory(:person)
        @third_person = Factory(:person, :email_notification_count => 1, :last_notification_email => Time.now - 60.hours )
        @forth_person = Factory(:person, :email_notification_count => 3, :last_notification_email => Time.now - 120.hours )
        @fifth_person = Factory(:person, :email_notification_count => 1, :last_notification_email => Time.now - 80.hours )
        @sixth_person = Factory(:person, :email_notification_count => 3, :last_notification_email => Time.now - 170.hours )
        @seventh_person = Factory(:person, :email_notification_count => 5, :last_notification_email => Time.now - 120.hours )
        @eight_person = Factory(:person, :email_notification_count => 3, :last_notification_email => Time.now - 60.hours )
        @nine_person = Factory(:person, :email_notification_count => 2, :last_notification_email => Time.now - 120.hours )
      end

      it "should return only authorised users, when users are inactive with certain conditions" do
        persons = Person.notification_candidate
        persons = [@second_person, @third_person, @forth_person]
      end

      it "should not return unauthorised users" do
        persons = Person.notification_candidate
        persons.should_not include{@first_person}
      end

      it "should not return when email notification count is more than 4" do
        persons = Person.notification_candidate
        persons.should_not include{@seventh_person}
      end
      it "should not return when email notification count is 2 but last notification is more than 68 hours" do
        persons = Person.notification_candidate
        persons.should_not include{@nine_person}
      end
      it "should not return when email notification count is 3, but last notification is sent less than 68 hours" do
        persons = Person.notification_candidate
        persons.should_not include{@eight_person}
      end
      it "should return authorised account" do
        persons = Person.notification_candidate
        persons.should include{@second_person}
      end

      describe "Only active users" do
        before do
          @active_user = Factory(:user)
          @unactive_user = Factory(:user, :last_activity => Time.now - 13.hours)
        end

        it "person scope should return only unactive user" do
          unactive_ids = User.unactive.collect(&:id)
          persons = Person.include_users(unactive_ids)
          persons.should be{[@unactive_user]}
        end

        it "person scope should not return active user" do
          unactive_ids = User.unactive.collect(&:id)
          persons = Person.include_users(unactive_ids)
          persons.should_not include{@active_user}
        end
      end
    end
  end
end

