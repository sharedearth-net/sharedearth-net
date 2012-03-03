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
end
