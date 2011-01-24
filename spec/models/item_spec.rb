require 'spec_helper'

describe Item do
  # include UserSpecHelper
  
  let(:person) { mock_model(Person) }

  it { should belong_to(:owner) }
  
  it { should validate_presence_of(:item_type) }

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:description) }

  it { should validate_presence_of(:owner_id) }
  
  it { should validate_presence_of(:owner_type) }
  
  it "should verify owner" do
    item = Item.new(:owner => person)
    item.is_owner?(person).should be_true
  end
  
  it "should verify owner (negative case)" do
    not_owner = mock_model(Person)
    item = Item.new(:owner => person)
    item.is_owner?(not_owner).should be_false
  end

end
