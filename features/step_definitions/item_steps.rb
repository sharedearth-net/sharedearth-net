Then /^I should not have a new Item$/ do
  Item.count.should == 0
end

Given /^the logged person is the owner$/ do
  person = Person.find_by_name!("logged person")
  last_item = model('that item')
  last_item.owner = person
  last_item.save!
end

Then /^the item description should be "([^"]*)"$/ do |description|
  last_item = model('that item')
  last_item.description.should match description
end
