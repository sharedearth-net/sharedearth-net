require 'spec_helper'

module ItemRequestSpecHelper
  def setup_item_request_helper_environment
    @requester_user = FactoryGirl.create(:user)
    @requester      = FactoryGirl.create(:person, :users => [@requester_user])
    reputation  = FactoryGirl.create(:reputation_rating, :person_id => @requester.id)
    @gifter_user = FactoryGirl.create(:user, :uid => '111')
    @gifter      = FactoryGirl.create(:person, :users => [@gifter_user])
    reputation  = FactoryGirl.create(:reputation_rating, :person_id => @gifter.id)
    @item        = FactoryGirl.create(:item, :owner => @gifter)
    @item_request = FactoryGirl.create(:item_request, :requester => @requester, :gifter => @gifter, :item => @item, :status => ItemRequest::STATUS_REQUESTED)
  end

  def setup_many_item_requests
    requester      = FactoryGirl.create(:person)
    requester1      = FactoryGirl.create(:person)
    gifter      = FactoryGirl.create(:person)
    item        = FactoryGirl.create(:item, :owner => gifter)
    @ir1 = FactoryGirl.create(:item_request, :requester => requester, :gifter => gifter, :item => item, :status => ItemRequest::STATUS_REQUESTED)
    @ir2 = FactoryGirl.create(:item_request, :requester => requester1, :gifter => gifter, :item => item, :status => ItemRequest::STATUS_REQUESTED)
  end

  def setup_shareage_environment
    @requester_user = FactoryGirl.create(:user)
    @requester      = FactoryGirl.create(:person, :users => [@requester_user])
    reputation  = FactoryGirl.create(:reputation_rating, :person_id => @requester.id)
    @gifter_user = FactoryGirl.create(:user, :uid => '111')
    @gifter      = FactoryGirl.create(:person, :users => [@gifter_user])
    reputation  = FactoryGirl.create(:reputation_rating, :person_id => @gifter.id)
    @item        = FactoryGirl.create(:item, :owner => @gifter, :purpose => Item::PURPOSE_SHAREAGE)
    @item_request = FactoryGirl.create(:item_request, :requester => @requester, :gifter => @gifter, :item => @item, :status => ItemRequest::STATUS_REQUESTED)
  end

  def setup_gift_environment
    @requester_user = FactoryGirl.create(:user)
    @requester      = FactoryGirl.create(:person, :users => [@requester_user])
    reputation  = FactoryGirl.create(:reputation_rating, :person_id => @requester.id)
    @gifter_user = FactoryGirl.create(:user, :uid => '111')
    @gifter      = FactoryGirl.create(:person, :users => [@gifter_user])
    reputation  = FactoryGirl.create(:reputation_rating, :person_id => @gifter.id)
    @item        = FactoryGirl.create(:item, :owner => @gifter, :purpose => Item::PURPOSE_GIFT)
    @item_request = FactoryGirl.create(:item_request, :requester => @requester, :gifter => @gifter, :item => @item, :status => ItemRequest::STATUS_REQUESTED)
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
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_REQUESTED)
    expect { @item_request.accept! }.to raise_error
  end

  after(:all) do
    #delete_item_request_helper_environment
  end
end

describe ItemRequest, ".accept! for shareage item" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_shareage_environment
  end

  it "should not be hidden when cancel is pressed" do
    @item_request.accept!
    @item.hidden?.should be_true
  end

  it "should be two records in resource network for same item" do
    @item_request.accept!
    resource = ResourceNetwork.item(@item_request.item)
    resource.length.should == 1
  end

  it "should update status to accepted" do
    expect { @item_request.accept! }.to change { @item_request.status }.from(ItemRequest::STATUS_REQUESTED).to(ItemRequest::STATUS_ACCEPTED)
  end

  it "should save the request object" do
    expect { @item_request.accept! }.to change { @item_request.status }.to(ItemRequest::STATUS_ACCEPTED)
  end

  it "should raise exception if request object is cannot be saved" do
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_REQUESTED)
    expect { @item_request.accept! }.to raise_error
  end

  it "should create activity log as for shareage item request as accepted" do
    @item_request.accept!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.shareage_accepted_requester).first

    expect {
      activity_log.reload
    }.to_not raise_exception
  end

  it "should create activity log as for shareage item request as accepted" do
    @item_request.accept!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.shareage_accepted_gifter).first

    expect {
      activity_log.reload
    }.to_not raise_exception
  end

  after(:all) do
    #delete_item_request_helper_environment
  end
end

describe ItemRequest, ".accept! for gift item" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_gift_environment
  end

  it "should update status to accepted" do
    expect { @item_request.accept! }.to change { @item_request.status }.from(ItemRequest::STATUS_REQUESTED).to(ItemRequest::STATUS_ACCEPTED)
  end

  it "should save the request object" do
    expect { @item_request.accept! }.to change { @item_request.status }.to(ItemRequest::STATUS_ACCEPTED)
  end

  it "should raise exception if request object is cannot be saved" do
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_REQUESTED)
    expect { @item_request.accept! }.to raise_error
  end

  it "should create activity log as for gift item request as accepted" do
    @item_request.accept!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.gift_accepted_requester).first

    expect {
      activity_log.reload
    }.to_not raise_exception
  end

  it "should create activity log as for gift item request as accepted" do
    @item_request.accept!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.gift_accepted_gifter).first

    expect {
      activity_log.reload
    }.to_not raise_exception
  end

  after(:all) do
    #delete_item_request_helper_environment
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
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_REQUESTED)
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
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_REQUESTED)
    expect { @item_request.cancel!(@requester) }.to raise_error
  end

end

describe ItemRequest, ".cancel! for shareage" do
  include ItemRequestSpecHelper
  before do
    setup_shareage_environment
    @item_request.accept!
  end

  it "should not be hidden when cancel is pressed" do
    @item_request.cancel!(@requester)
    @item.hidden?.should be_false
  end

  it "should create cancel shareage event log for gifter when gifter canceled" do
    @item_request.cancel!(@gifter)
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.shareage_gifter_canceled_gifter).first
    activity_log.should_not be_nil
  end

  it "should create cancel shareage event log for requester when gifter canceled" do
    @item_request.cancel!(@gifter)
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.shareage_gifter_canceled_requester).first
    activity_log.should_not be_nil
  end

  it "should create cancel shareage event log for gifter when requester canceled" do
    @item_request.cancel!(@requester)
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.shareage_requester_canceled_gifter).first
    activity_log.should_not be_nil
  end

  it "should create cancel shareage event log for requester when gifter canceled" do
    @item_request.cancel!(@requester)
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.shareage_requester_canceled_requester).first
    activity_log.should_not be_nil
  end
end

describe ItemRequest, ".collected!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_item_request_helper_environment
    @item_request.update_attributes(:status => ItemRequest::STATUS_ACCEPTED)
  end

  it "should update status to collected" do
    expect { @item_request.collected! }.to change { @item_request.status }.to(ItemRequest::STATUS_COLLECTED)
  end

  it "should save the request object" do
    expect { @item_request.collected! }.to change { @item_request.status }.to(ItemRequest::STATUS_COLLECTED)
  end

  it "should raise exception if request object is cannot be saved" do
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_ACCEPTED)
    expect { @item_request.collected! }.to raise_error
  end
end

describe ItemRequest, ".complete!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_item_request_helper_environment
    @item_request.update_attributes(:status => ItemRequest::STATUS_ACCEPTED)
  end

  it "should update status to completed" do
    expect { @item_request.complete!(@requester) }.to change { @item_request.status }.to(ItemRequest::STATUS_COMPLETED)
  end

  it "should save the request object" do
    expect { @item_request.complete!(@requester) }.to change { @item_request.status }.to(ItemRequest::STATUS_COMPLETED)
  end

  it "should raise exception if request object is cannot be saved" do
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_ACCEPTED)
    expect { @item_request.complete!(@requester) }.to raise_error
  end

end

describe ItemRequest do
  include ItemRequestSpecHelper
  before do
    setup_many_item_requests
  end

  it "should accept current item requests" do
    expect { @ir1.accept! }.to change{@ir1.status}.from(ItemRequest::STATUS_REQUESTED).to(ItemRequest::STATUS_ACCEPTED)
  end

  it "should deline all other item requests" do
    @ir1.accept!
    @ir2.status == ItemRequest::STATUS_REJECTED
  end
end

describe ItemRequest do
  include ItemRequestSpecHelper
  before do
    setup_shareage_environment
  end

  it "should create activity log for shareage for requester" do
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.new_shareage_item_request_requester).first

    expect {
      activity_log.reload
    }.to_not raise_exception
  end

  it "should create activity log for shareage for gifter" do
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.new_shareage_item_request_gifter).first

    expect {
      activity_log.reload
    }.to_not raise_exception
  end

  it "should not create activity log as for regular item request" do
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.new_item_request_requester).first

    expect {
      activity_log.reload
    }.to raise_exception
  end

  it "should not create activity log as for regular item request" do
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.new_item_request_gifter).first

    expect {
      activity_log.reload
    }.to raise_exception
  end

end


describe ItemRequest, ".collected! for shareage" do
  include ItemRequestSpecHelper
  before do
    setup_shareage_environment
    @item_request.accept!
    @item_request.collected!
  end

  it "should update item status to shareage" do
    @item_request.item.status.should == Item::STATUS_SHAREAGE
  end

  it "should update status to collected" do
    @item_request.status.should == ItemRequest::STATUS_SHAREAGE
  end

  it "should update item status to shareage" do
    @item_request.item.status.should == Item::STATUS_SHAREAGE
  end

  it "should be two records in resource network for same item" do
    resource = ResourceNetwork.item(@item_request.item)
    resource.length.should == 2
  end

  it "should be no gifter_possessor record" do
    resource = ResourceNetwork.item(@item_request.item).gifter_possessor
    resource.length.should == 0
  end

  it "should change to gifter resource" do
    resource = ResourceNetwork.item(@item_request.item).gifter
    resource.length.should == 1
  end

  it "should create possessor resource" do
    resource = ResourceNetwork.item(@item_request.item).possessor
    resource.length.should == 1
  end

  it "should create activity log for shareage for gifter" do
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.collected_shareage_gifter).first

    expect {
      activity_log.reload
    }.to_not raise_exception
  end

  it "should create activity log for shareage for requester" do
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.collected_shareage_requester).first

    expect {
      activity_log.reload
    }.to_not raise_exception
  end

end


describe ItemRequest, ".complete!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_item_request_helper_environment
    @item_request.update_attributes(:status => ItemRequest::STATUS_ACCEPTED)
  end

  it "should update status to completed" do
    expect { @item_request.complete!(@requester) }.to change { @item_request.status }.to(ItemRequest::STATUS_COMPLETED)
  end

  it "should save the request object" do
    expect { @item_request.complete!(@requester) }.to change { @item_request.status }.to(ItemRequest::STATUS_COMPLETED)
  end

  it "should raise exception if request object is cannot be saved" do
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_ACCEPTED)
    expect { @item_request.complete!(@requester) }.to raise_error
  end

end

describe ItemRequest, ".recall!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_shareage_environment
    @item_request.accept!
    @item_request.collected!
  end

  it "should update status to recalled" do
    expect { @item_request.recall! }.to change { @item_request.status }.from(ItemRequest::STATUS_SHAREAGE).to(ItemRequest::STATUS_RECALL)
  end

  it "should save the request object" do
    expect { @item_request.recall! }.to change { @item_request.status }.to(ItemRequest::STATUS_RECALL)
  end

  it "should raise exception if request object is cannot be saved" do
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_SHAREAGE)
    expect { @item_request.recall! }.to raise_error
  end

  it "should create activity log for gifter" do
    @item_request.recall!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.recall_shareage_gifter).first

    activity_log.should_not be_nil
  end

  it "should create activity log for requester" do
    @item_request.recall!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.recall_shareage_requester).first

    activity_log.should_not be_nil
  end

  after(:all) do
    #delete_item_request_helper_environment
  end
end

describe ItemRequest, ".return!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_shareage_environment
    @item_request.accept!
    @item_request.collected!
  end

  it "should update status to return" do
    expect { @item_request.return! }.to change { @item_request.status }.from(ItemRequest::STATUS_SHAREAGE).to(ItemRequest::STATUS_RETURN)
  end

  it "should save the request object" do
    expect { @item_request.return! }.to change { @item_request.status }.to(ItemRequest::STATUS_RETURN)
  end

  it "should raise exception if request object is cannot be saved" do
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_SHAREAGE)
    expect { @item_request.return! }.to raise_error
  end

  it "should create activity log for gifter" do
    @item_request.return!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.return_shareage_gifter).first

    activity_log.should_not be_nil
  end

  it "should create activity log for requester" do
    @item_request.return!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.return_shareage_requester).first

    activity_log.should_not be_nil
  end
  after(:all) do
    #delete_item_request_helper_environment
  end
end

describe ItemRequest, ".cancel_recall!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_shareage_environment
    @item_request.accept!
    @item_request.collected!
    @item_request.recall!
  end

  it "should update status to cancel recall" do
    expect { @item_request.cancel_recall! }.to change { @item_request.status }.from(ItemRequest::STATUS_RECALL).to(ItemRequest::STATUS_SHAREAGE)
  end

  it "should save the request object" do
    expect { @item_request.cancel_recall! }.to change { @item_request.status }.to(ItemRequest::STATUS_SHAREAGE)
  end

  it "should raise exception if request object is cannot be saved" do
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_RECALL)
    expect { @item_request.cancel_recall! }.to raise_error
  end

  it "should create activity log for gifter" do
    @item_request.cancel_recall!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.cancel_recall_shareage_gifter).first

    activity_log.should_not be_nil
  end

  it "should create activity log for requester" do
    @item_request.cancel_recall!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.cancel_recall_shareage_requester).first

    activity_log.should_not be_nil
  end

  after(:all) do
    #delete_item_request_helper_environment
  end
end

describe ItemRequest, ".cancel_return!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_shareage_environment
    @item_request.accept!
    @item_request.collected!
    @item_request.return!
  end

  it "should update status to cancel return" do
    expect { @item_request.cancel_return! }.to change { @item_request.status }.from(ItemRequest::STATUS_RETURN).to(ItemRequest::STATUS_SHAREAGE)
  end

  it "should save the request object" do
    expect { @item_request.cancel_return! }.to change { @item_request.status }.to(ItemRequest::STATUS_SHAREAGE)
  end

  it "should raise exception if request object is cannot be saved" do
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_RETURN)
    expect { @item_request.cancel_return! }.to raise_error
  end

  it "should create activity log for gifter" do
    @item_request.cancel_return!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.cancel_return_shareage_gifter).first

    activity_log.should_not be_nil
  end

  it "should create activity log for requester" do
    @item_request.cancel_return!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.cancel_return_shareage_requester).first

    activity_log.should_not be_nil
  end
  after(:all) do
    #delete_item_request_helper_environment
  end
end

describe ItemRequest, ".acknowledge!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_shareage_environment
    @item_request.accept!
    @item_request.collected!
  end

  context "after recall request" do
    before do
      @item_request.recall!
    end

    it "should update status to acknowledged" do
      expect { @item_request.acknowledge! }.to change { @item_request.status }.from(ItemRequest::STATUS_RECALL).to(ItemRequest::STATUS_ACKNOWLEDGED)
    end

    it "should save the request object" do
      expect { @item_request.acknowledge! }.to change { @item_request.status }.to(ItemRequest::STATUS_ACKNOWLEDGED)
    end

    it "should raise exception if request object is cannot be saved" do
      # invalid object attrs
      @item_request = ItemRequest.new(:status => ItemRequest::STATUS_RECALL)
      expect { @item_request.acknowledge! }.to raise_error
    end

    it "should create activity log for gifter" do
      @item_request.acknowledge!
      activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.acknowledge_shareage_gifter).first

      activity_log.should_not be_nil
    end

    it "should create activity log for requester" do
      @item_request.acknowledge!
      activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.acknowledge_shareage_requester).first

      activity_log.should_not be_nil
    end
  end

  context "after return request" do
    before do
      @item_request.return!
    end

    it "should update status to acknowledged" do
      expect { @item_request.acknowledge! }.to change { @item_request.status }.from(ItemRequest::STATUS_RETURN).to(ItemRequest::STATUS_ACKNOWLEDGED)
    end

    it "should save the request object" do
      expect { @item_request.acknowledge! }.to change { @item_request.status }.to(ItemRequest::STATUS_ACKNOWLEDGED)
    end

    it "should raise exception if request object is cannot be saved" do
      # invalid object attrs
      @item_request = ItemRequest.new(:status => ItemRequest::STATUS_RETURN)
      expect { @item_request.acknowledge! }.to raise_error
    end

    it "should create activity log for gifter" do
      @item_request.acknowledge!
      activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.acknowledge_return_shareage_gifter).first

      activity_log.should_not be_nil
    end

    it "should create activity log for requester" do
      @item_request.acknowledge!
      activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.acknowledge_return_shareage_requester).first

      activity_log.should_not be_nil
    end
  end

  after(:all) do
    #delete_item_request_helper_environment
  end
end

describe ItemRequest, ".returned!" do
  include ItemRequestSpecHelper

  before(:each) do
    setup_shareage_environment
    @item_request.accept!
    @item_request.collected!
    @item_request.return!
    @item_request.acknowledge!
  end

  it "should update status to returned" do
    expect { @item_request.returned! }.to change { @item_request.status }.from(ItemRequest::STATUS_ACKNOWLEDGED).to(ItemRequest::STATUS_RETURNED)
  end

  it "should save the request object" do
    expect { @item_request.returned! }.to change { @item_request.status }.to(ItemRequest::STATUS_RETURNED)
  end

  it "should raise exception if request object is cannot be saved" do
    # invalid object attrs
    @item_request = ItemRequest.new(:status => ItemRequest::STATUS_ACKNOWLEDGED)
    expect { @item_request.returned! }.to raise_error
  end

  it "should create activity log for gifter" do
    @item_request.returned!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.returned_shareage_gifter).first

    activity_log.should_not be_nil
  end

  it "should create activity log for requester" do
    @item_request.returned!
    activity_log = @item_request.item.activity_logs.where(:event_type_id => EventType.returned_shareage_requester).first

    activity_log.should_not be_nil
  end

    it "should remove from resource network and leave just for original gifter" do
      @item_request.returned!
      resource = ResourceNetwork.item(@item_request.item)
      resource.length.should == 1
    end

    it "should remove from resource network and leave just for original gifter" do
      @item_request.returned!
      resource = ResourceNetwork.item(@item_request.item).gifter
      resource.length.should == 0
    end

    it "should remove from resource network and leave just for original gifter" do
      @item_request.returned!
      resource = ResourceNetwork.item(@item_request.item).gifter_possessor
      resource.length.should == 1
    end

    it "should be unhidden" do
      @item_request.returned!
      @item_request.item.hidden?.should be_false
    end

    it "should be available" do
      @item_request.returned!
      @item_request.item.available?.should be_true
    end

    it "should return to normal status" do
      @item_request.returned!
      @item_request.item.normal?
    end

    it "should update number of gift actions for gifter" do
      @item_request.returned!
      @item_request.gifter.reputation_rating.gift_actions.should == 1
    end

    it "should update total number of actions for gifter" do
      @item_request.returned!
      @item_request.gifter.reputation_rating.total_actions.should == 1
    end

    it "should update number of gift actions for requester" do
      @item_request.returned!
      @item_request.requester.reputation_rating.gift_actions.should_not == 1
    end

    it "should update total actions for requester" do
      @item_request.returned!
      @item_request.requester.reputation_rating.total_actions.should == 1
    end

    it "should update distinct people count for gifter" do
      @item_request.returned!
      @item_request.gifter.reputation_rating.distinct_people.should == 1
    end

    it "should create event log for shareage" do
      @item_request.returned!
      event_log = @item_request.item.event_logs.where(:event_type_id => EventType.shareage).first

      expect {
        event_log.reload
      }.to_not raise_exception
    end
  after(:all) do
    #delete_item_request_helper_environment
  end
end
