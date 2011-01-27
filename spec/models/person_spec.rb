require 'spec_helper'

describe Person do
  let(:user) { mock_model(User) }

  it { should belong_to(:user) }
  
  it { should validate_presence_of(:user_id) }

  it { should have_many(:items) }
  
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
