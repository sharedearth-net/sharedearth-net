require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ItemsHelper. For example:
#
# describe ItemsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ItemsHelper do
  
  describe "generic name" do
    it "should return name of item if name is provided" do
      item = Factory :item, :name => "Royal Enfield"
      "Royal Enfield".should == generic_name(item)
    end
    
    it "should return item type of item is name is not provided" do
      item = Factory :item, :name => "", :item_type => "bike"
      "bike".should == generic_name(item)
    end    
  end
  
  describe "truncateItemType" do 
    it "should not truncate item types under 23 characters" do
      short_item_type = "shortstring"
      truncated_item_type = truncateItemType(short_item_type)
      truncated_item_type.should == short_item_type
	end 
	
    it "should truncate item types over 23 characters" do
      long_item_type = "thisisastringthatisover23characters"
      truncated_item_type = truncateItemType(long_item_type)
      long_item_type[0..20].should == truncated_item_type[0..20]
      truncated_item_type[21..22].should == ".."
      truncated_item_type.length.should == 23
    end
  end
  
  describe "truncateItemName" do 
    it "should not truncate item names under 48 characters" do
      short_item_name = "shortname"
      truncated_item_name = truncateItemName(short_item_name)
      truncated_item_name.should == short_item_name
	end
	
    it "should truncate item names over 48 characters" do
      long_item_name = "Lorem ipsum dolor sit amet, consectetur adipiscing"
      truncated_item_name = truncateItemName(long_item_name)
      long_item_name[0..45].should == truncated_item_name[0..45]
      truncated_item_name[46..48].should == ".."
      truncated_item_name.length.should == 48
	end
  end
end
