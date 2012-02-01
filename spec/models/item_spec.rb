require 'spec_helper'

describe Item do
  let(:person) { mock_model(Person) }

  let(:long_item_type) { 'l' * 31 }

  let(:long_name) { 'i' * 51 }

  let(:long_description) { 'f' * 401 }

  it { should belong_to(:owner) }

  it { should have_many(:item_requests) }

  it { should validate_presence_of(:purpose) }

  it { should validate_presence_of(:item_type) }

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:status) }

  it { should validate_presence_of(:owner_id) }

  it { should validate_presence_of(:owner_type) }

  it { should_not allow_value(Item::PURPOSE_SHAREAGE).for(:purpose) }

  it { should_not allow_value(Item::PURPOSE_COMMUNAL).for(:purpose) }

  it { should_not allow_value(long_item_type).for(:item_type) }

  it { should_not allow_value(long_name).for(:name) }

  it { should_not allow_value(long_description).for(:description) }

  before(:each) do
    File.stub!(:unlink).and_return(true)
  end
  it "should have a 'deleted' flag" do
    item = Factory(:item)
    item.should respond_to(:deleted)
  end

  it "should have the 'deleted' flag default to false" do
    item = Factory(:item)
    item.should_not be_deleted
  end

  it "should transfer ownership to new owner" do
    #TO DO check if ownership is transfered
  end

  it "should check type of the item" do
    #TO DO check purpose of the item - for sharing or gifting
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

end
describe Item, ".add_owner for shareage" do
  let(:item) {Factory(:item)}
  let(:requester) {Factory(:person)}
  before do
    File.stub!(:unlink).and_return(true)
  end

  it "add new owner to resource network" do
    item.add_to_resource_network_for(requester)
    resource = ResourceNetwork.item(item).entity(requester)
    resource.should_not be_empty
  end

  it "remove new owner to resource network" do
    item.add_to_resource_network_for(requester)
    item.remove_from_resource_network_for(requester)
    resource = ResourceNetwork.item(item).entity(requester)
    resource.should be_empty
  end
end

describe Item, ".delete" do

  let(:item) { Factory(:item) }
  before(:each) do
    File.stub!(:unlink).and_return(true)
  end

  it "should set the 'deleted' flag to true" do
    item.delete
    item.should be_deleted
  end

  it "should delete all the Activity Log concerning the item creation" do
    item.create_new_item_activity_log
    activity_log = item.activity_logs.where(:event_type_id => EventType.add_item).first
    item.delete

    expect {
      activity_log.reload
    }.to raise_exception
  end

  it "should delete all the Event Logs concerning the item creation" do
    EventLog.create_news_event_log(item.owner, nil,  item , EventType.add_item, item)
    event_log = item.event_logs.where(:event_type_id => EventType.add_item).first
    item.delete

    expect {
      event_log.reload
    }.to raise_error
  end

  it "should set the item name 'This item has been deleted'" do
    item.delete
    item.reload
    item.name.should match 'This item has been deleted'
  end

  it "should clear the item's description" do
    item.delete
    item.reload
    item.description.should be_empty
  end

  it "should remove the item's photo" do
    item.delete
    item.reload
    item.photo.should_not be_present
  end
end

describe Item, '.search' do
  before(:each) do
    File.stub!(:unlink).and_return(true)
  end
  let(:items_requester) { Factory(:person) }

  let(:items_owner) { Factory(:person) }

  let(:item_type_car) { Factory(:item, :item_type => 'car', :owner => items_owner) }

  let(:item_named_stuff) { Factory(:item, :name => 'stuff', :owner => items_owner) }

  let(:item_with_description) { Factory(:item, :description => 'Deux', :owner => items_owner) }

  let(:item_deleted) { Factory(:item, :name => 'deleted', :owner => items_owner) }

  let(:item_hidden) { Factory(:item, :name => 'hidden', :owner => items_owner, :hidden => true)}

  before :each do
    PeopleNetwork.create_trust!(items_owner, items_requester)

    # Create a resource_network for each item
    [item_type_car, item_named_stuff, item_with_description].each do |item|
      Factory(:resource_network, :resource_id => item.id, :entity_id => items_requester.id)
    end

    # Create a 'duplicated' resource_network for testing purposes
    Factory(:resource_network, :resource_id => item_named_stuff,
            :entity_id => items_requester.id)

    item_deleted.delete
  end

  it "should return nil if the search term is empty" do
    Item.search('', items_requester.id).should be_nil
  end

  it "should return the right item when searching for a specific type" do
    result = Item.search('car', items_requester.id)
    result.should include(item_type_car)
  end

  it "should return the right item when searching for a specific name" do
    result = Item.search('stuff', items_requester.id)
    result.should include(item_named_stuff)
  end

  it "should return the right item when searching for a specific description" do
    result = Item.search('Deux', items_requester.id)
    result.should include(item_with_description)
  end

  it "should not return duplicated items" do
    result = Item.search('stuff', items_requester.id)
    result.should have(1).items
  end

  it "should not return deleted items" do
    Item.search('deleted', items_requester.id).should be_empty
  end

  it "should ignore the text case" do
    Item.search('StuFf', items_requester.id).should_not be_empty
  end

  it "should not return hidden items" do
    Item.search('hidden', items_requester.id).should be_empty
  end
end
