require 'spec_helper'

describe Person do

  let(:user) { mock_model(User) }

  it { should belong_to(:user) }
  
  it { should validate_presence_of(:user_id) }

  it { should have_many(:items) }

  it { should have_many(:item_requests) }

  it { should have_many(:item_gifts) }
  
  it { should validate_presence_of(:name) }

  it "should check if it belongs to user" do
    person = Person.new(:user => user)
    person.belongs_to?(user).should be_true
  end
  
  it "should check if it belongs to user (negative case)" do
    some_other_user = mock_model(User)
    person = Person.new(:user => user)
    person.belongs_to?(some_other_user).should be_false
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
    person = stub_model(Person, :name => "Receiver")
    expect {
      person.request_trusted_relationship(request_person)
    }.to change { person.received_people_network_requests.count }.by(1)
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
