Given /^me and "([^"]*)" are friends on FB$/ do |other_person_name|
  other_person  = Person.find_by_name(other_person_name)
  FbService.stub!(:get_my_friends).and_return([other_person])
end

Given /^me and "([^"]*)" have a trust relationship$/ do |other_person_name|
  logged_person = Person.find(1)
  other_person  = Person.find_by_name(other_person_name)

  Factory(:people_network, 
          :trusted_person_id => other_person.id, 
          :person_id         => logged_person.id)
end

Given /^I have made a trust request to "([^"]*)"$/ do |person_name|
  requested = Person.find_by_name(person_name)
  page.driver.post(people_network_requests_path(:trusted_person_id => requested.id))
end

Given /^"([^"]*)" and "([^"]*)" are my friends on FB$/ do |arg1, arg2|
  first_person  = Person.find_by_name(arg1)
  second_person = Person.find_by_name(arg2)

  FbService.stub!(:get_my_friends).and_return([first_person, second_person])
end
