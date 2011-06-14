require 'spec_helper'

module ItemRequestSpecHelper
  def setup_item_request_helper_environment
    @requester_user = Factory(:user)
    @requester      = Factory(:person, :user => @requester_user)
    reputation  = Factory(:reputation_rating, :person_id => @requester.id)
    @gifter_user = Factory(:user, :uid => '111')
    @gifter      = Factory(:person, :user => @gifter_user)
    reputation  = Factory(:reputation_rating, :person_id => @gifter.id)
    @item        = Factory(:item, :owner => @gifter)
    @item_request = Factory(:item_request, :requester => @requester, :gifter => @gifter, :item => @item, :status => ItemRequest::STATUS_REQUESTED)
  end
  
  def delete_item_request_helper_environment
    @item_request.delete
    @gifter.delete
    @gifter_user.delete
    @requester.delete
    @requster_user.delete
  end
  def valid_item_request_attributes
    {
      :requester_id => 1,
      :requester_type => "Person",
      :gifter_id => 2,
      :gifter_type => "Person",
      :item_id => @item.id,
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
    setup_item_request_helper_environment
  end
  
  it "should update status to accepted" do
    expect { @item_request.accept! }.to change { @item_request.status }.from(ItemRequest::STATUS_REQUESTED).to(ItemRequest::STATUS_ACCEPTED)
  end

  it "should save the request object" do
    expect { @item_request.accept! }.to change { @item_request.status }.to(ItemRequest::STATUS_ACCEPTED)
  end

  it "should raise exception if request object is cannot be saved" do
    @item_request = ItemRequest.new # invalid object attrs
    expect { @item_request.accept! }.to raise_error
  end
  after(:all) do
    delete_item_request_helper_environment
  end
end

describe ItemRequest, ".reject!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_item_request_helper_environment
  end
  
  it "should update status to rejected" do
    expect { @item_request.reject! }.to change { @item_request.status }.from(ItemRequest::STATUS_REQUESTED).to(ItemRequest::STATUS_REJECTED)
  end

  it "should save the request object" do
    expect { @item_request.reject! }.to change { @item_request.status }.to(ItemRequest::STATUS_REJECTED)
  end

  it "should raise exception if request object is cannot be saved" do
    @item_request = ItemRequest.new # invalid object attrs
    expect { @item_request.reject! }.to raise_error
  end

end

describe ItemRequest, ".cancel!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_item_request_helper_environment
  end
  
  it "should update status to canceled" do
    expect { @item_request.cancel!(@requester) }.to change { @item_request.status }.from(ItemRequest::STATUS_REQUESTED).to(ItemRequest::STATUS_CANCELED)
  end

  it "should save the request object" do
    expect { @item_request.cancel!(@requester) }.to change { @item_request.status }.to(ItemRequest::STATUS_CANCELED)
  end

  it "should raise exception if request object is cannot be saved" do
    @item_request = ItemRequest.new # invalid object attrs
    expect { @item_request.cancel!(@requester) }.to raise_error
  end

end

describe ItemRequest, ".collected!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_item_request_helper_environment
  end
  
  it "should update status to collected" do
    expect { @item_request.collected! }.to change { @item_request.status }.to(ItemRequest::STATUS_COLLECTED)
  end

  it "should save the request object" do
    expect { @item_request.collected! }.to change { @item_request.status }.to(ItemRequest::STATUS_COLLECTED)
  end

  it "should raise exception if request object is cannot be saved" do
    @item_request = ItemRequest.new # invalid object attrs
    expect { @item_request.collected! }.to raise_error
  end
end

describe ItemRequest, ".complete!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_item_request_helper_environment
  end
  
  it "should update status to completed" do
    expect { @item_request.complete!(@requester) }.to change { @item_request.status }.to(ItemRequest::STATUS_COMPLETED)
  end

  it "should save the request object" do
    expect { @item_request.complete!(@requester) }.to change { @item_request.status }.to(ItemRequest::STATUS_COMPLETED)
  end

  it "should raise exception if request object is cannot be saved" do
    @item_request = ItemRequest.new # invalid object attrs
    expect { @item_request.complete!(@requester) }.to raise_error
  end

end
