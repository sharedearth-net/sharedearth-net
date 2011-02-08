require 'spec_helper'

module ItemRequestSpecHelper

  def valid_item_request_attributes
    {
      :requester_id => 1,
      :requester_type => "Person",
      :gifter_id => 2,
      :gifter_type => "Person",
      :item_id => 3,
      :description => "ItemRequestDescription",
      :status => ItemRequest::STATUS_REQUESTED
    }
  end

end

describe ItemRequest do

  it { should belong_to(:requester) }

  it { should belong_to(:gifter) }
  
  it { should belong_to(:item) }
  
  # it { should validate_presence_of(:description) }

  it { should validate_presence_of(:requester_id) }

  it { should validate_presence_of(:requester_type) }

  it { should validate_presence_of(:item_id) }

  it { should validate_presence_of(:status) }

  it "should validate inclusion of status in predefined values" do
    ItemRequest::STATUSES.keys.each do |status|
      should allow_value(status).for(:status)
    end
  end

  it { should_not allow_value("bad status").for(:status) }

end

describe ItemRequest, ".status_name" do

  it "should return correct status name" do
    item_request = ItemRequest.new(:status => ItemRequest::STATUS_REQUESTED)
    item_request.status_name.should eql(ItemRequest::STATUSES[ItemRequest::STATUS_REQUESTED])
  end

end

describe ItemRequest, ".requester?" do
  
  let(:mock_person) { mock_model(Person) }

  before(:each) do
    @item_request = ItemRequest.new(:requester => mock_person)
  end

  it "should return true if given object is requester" do
    @item_request.requester?(mock_person).should be_true
  end

  it "should return false if given object is not requester" do
    some_other_person = mock_model(Person)
    @item_request.requester?(some_other_person).should be_false
  end

end

describe ItemRequest, ".gifter?" do

  let(:mock_person) { mock_model(Person) }

  before(:each) do
    @item_request = ItemRequest.new(:gifter => mock_person)
  end
  
  it "should return true if given object is gifter" do
    @item_request.gifter?(mock_person).should be_true
  end

  it "should return false if given object is not gifter" do
    some_other_person = mock_model(Person)
    @item_request.gifter?(some_other_person).should be_false
  end

end

describe ItemRequest, ".accept!" do
  include ItemRequestSpecHelper

  before(:each) do
    @item_request = ItemRequest.new(valid_item_request_attributes)
  end
  
  it "should update status to accepted" do
    expect { @item_request.accept! }.to change { @item_request.status }.from(ItemRequest::STATUS_REQUESTED).to(ItemRequest::STATUS_ACCEPTED)
  end

  it "should save the request object" do
    expect { @item_request.accept! }.to change { @item_request.changed? }.to(false)
  end

  it "should raise exception if request object is cannot be saved" do
    @item_request = ItemRequest.new # invalid object attrs
    expect { @item_request.accept! }.to raise_error
  end

end

describe ItemRequest, ".reject!" do
  include ItemRequestSpecHelper

  before(:each) do
    @item_request = ItemRequest.new(valid_item_request_attributes)
  end
  
  it "should update status to rejected" do
    expect { @item_request.reject! }.to change { @item_request.status }.from(ItemRequest::STATUS_REQUESTED).to(ItemRequest::STATUS_REJECTED)
  end

  it "should save the request object" do
    expect { @item_request.reject! }.to change { @item_request.changed? }.to(false)
  end

  it "should raise exception if request object is cannot be saved" do
    @item_request = ItemRequest.new # invalid object attrs
    expect { @item_request.reject! }.to raise_error
  end

end