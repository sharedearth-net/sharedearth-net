require 'spec_helper'

describe ItemType do
  it "should increase item count by 1" do
    item_type = Factory(:item_type, :item_type => 'Bike')
    item_type.item_count.should == 1
    item_type.increase_item_count
    item_type.item_count.should == 2
  end
  
  it "should reduce item count by 1" do
    item_type = Factory(:item_type, :item_type => 'Bike')
    item_type.item_count.should == 1
    item_type.reduce_item_count
    item_type.item_count.should == 0
  end
  
  it "should create new item type from item" do
    item = Factory.build(:item, :item_type => 'Bike', :name => nil)
    ItemType.create_from_item item
    
    item_types = ItemType.where(:item_type => item.item_type)
    item_types.count.should == 1
    item_types.first.item_count.should == 1
  end
end