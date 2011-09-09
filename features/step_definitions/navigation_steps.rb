Given /^Looking at person page with name "([^"]*)"$/ do |name|
  person = Person.find_by_name("#{name}")
  visit person_path(person)
end

Given /^Looking at my person page$/ do
  person = Person.find_by_name("John")
  visit person_path(person)
end

Given /^Looking at person network page with name "([^"]*)"$/ do |name|
  person = Person.find_by_name("#{name}")
  visit network_person_path(person)
end

When /^I submit the comment$/ do
 find_field('comment').native.send_key(:enter)
end
