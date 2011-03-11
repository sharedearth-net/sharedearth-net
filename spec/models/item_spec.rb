require 'spec_helper'

describe Item do
  # include UserSpecHelper
  
  let(:person) { mock_model(Person) }

  it { should belong_to(:owner) }

  it { should have_many(:item_requests) }
  
  it { should validate_presence_of(:item_type) }

  it { should validate_presence_of(:name) }

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

  it { should have_attached_file(:photo) }
  # it { should validate_attachment_presence(:photo) }
  it { should validate_attachment_content_type(:photo).
                allowing('image/png', 'image/gif', 'image/jpeg', 'image/jpg').
                rejecting('text/plain', 'text/xml') }
  # apparently when should validate_attachment_size is run under Ruby 1.8.7 it hangs
  # (it should work correctly under Ruby 1.9.2+). For now we'll just comment it out.
  # it { should validate_attachment_size(:photo).less_than(1.megabyte) }

  pending "should respond do deleted?" # test deleted? method
  pending "should be soft-deleted (delete)" # test delete method
  pending "should be able to get restored" # test restore method


end
