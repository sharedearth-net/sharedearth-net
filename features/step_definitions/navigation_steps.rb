Given /^Looking at person page with name "([^"]*)"$/ do |name|
  person = Person.find_by_name("#{name}")
  visit person_path(person)
end

Given /^Looking at my person page$/ do
  person = Person.find_by_name("John")
  visit person_path(person)
end


