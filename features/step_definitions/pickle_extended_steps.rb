Given /^"(.*)" is the owner of item with name "(.*)"$/ do |name, item|
    person = Person.find_by_name("#{name}")
    Factory(:item, :owner_id => person.id, :name => item)
end

Given /^I am the owner of item with name "(.*)"$/ do |item|
    person = Person.find_by_name("John")
    Factory(:item, :owner_id => person.id, :name => item)
end

Given /^Person with name "(.*)" requested my item with name "(.*)"$/ do |person,item|
    person = Person.find_by_name("#{person}")
    me = Person.find_by_name("John")
    item = Item.find_by_name("#{item}")
    Factory(:item_request, :requester_id => person.id, :gifter_id => me.id, :item_id => item.id)
end

Given /^I requested item with name "(.*)" from person with name "(.*)"$/ do |item, person|
    person = Person.find_by_name("#{person}")
    me = Person.find_by_name("John")
    item = Item.find_by_name("#{item}")
    Factory(:item_request, :requester_id => me.id, :gifter_id => person.id, :item_id => item.id)
end
