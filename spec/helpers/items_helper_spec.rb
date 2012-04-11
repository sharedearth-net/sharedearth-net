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
  
  describe "truncate" do 
    it "should not truncate item types under 23 characters" do
      short_item_type = "shortstring"
      truncated_item_type = truncate(short_item_type)
      truncated_item_type.should == short_item_type
	end 
	
    it "should truncate item types over 23 characters" do
      long_item_type = "thisisastringthatisover23characters"
      truncated_item_type = truncate(long_item_type)
      long_item_type[0..20].should == truncated_item_type[0..20]
      truncated_item_type[21..22].should == ".."
      truncated_item_type.length.should == 23
    end
  end
end
