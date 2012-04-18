require 'spec_helper'
module ResourceNetworkHelperSpec
  def setup_resource_network_environment
    person = Factory(:person)
    @item = Factory(:item)
    @resource_network = Factory(:resource_network, :entity_id => person.id, :resource_id => @item.id)
  end

end

describe ResourceNetwork do
  it {should validate_presence_of(:type)}
  it "should allow preset values as values for type" do
    ResourceNetwork::TYPES.each do |type|
      should allow_value(type).for(:type)
    end
  end
end
describe ResourceNetwork do
  include ResourceNetworkHelperSpec
  before do
    setup_resource_network_environment
    @new_owner = Factory(:person)
  end
  it ".set_possessor! should set possessor to new entity" do
    expect {@resource_network.set_possessor!(@new_owner,1)}.to change { @resource_network.type }.from(ResourceNetwork::TYPE_GIFTER_AND_POSSESSOR).to(ResourceNetwork::TYPE_GIFTER)
  end
end
describe ResourceNetwork do
  include ResourceNetworkHelperSpec
  before do
    setup_resource_network_environment
    @new_owner = Factory(:person)
  end
  it ".remove_possessor! should remove possessor id but not the item id itself" do
    expect {@resource_network.remove_possessor!}.to change { @resource_network.entity_id }.from(@resource_network.entity_id).to(nil)
  end
  it ".remove_possessor! should set default type to resource network" do
    @resource_network.set_possessor!(@new_owner, 1)
    expect {@resource_network.remove_possessor!}.to change { @resource_network.type }.from(ResourceNetwork::TYPE_GIFTER).to(ResourceNetwork::TYPE_GIFTER_AND_POSSESSOR)
  end
end

describe ResourceNetwork do
  include ResourceNetworkHelperSpec
  before do
    setup_resource_network_environment
  end

  it "should find item associated with Resource Network" do
    expect {ResourceNetwork.item(@item).first}.to_not raise_error
  end

end

describe "Scopes" do

    describe "#group scope" do
      before :each do
      end

      it "should return a list of comments ordered by creation date" do
#        users = User.unactive
#        users.should == [@second_user]
      end
    end
end
