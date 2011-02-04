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

describe Person, ".all_requests" do

  it "should return all requests for this person (both as gifter and requester)" do
    person = Person.new
    first_request = mock_model(ItemRequest)
    second_request = mock_model(ItemRequest)
    person.stub(:item_requests).and_return([first_request])
    person.stub(:item_gifts).and_return([second_request])

    person.all_requests.should eql([first_request, second_request])
  end

end