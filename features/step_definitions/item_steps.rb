Then /^I should not have a new Item$/ do
  Item.count.should == 0
end
