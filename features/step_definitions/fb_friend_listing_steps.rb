Given /^me and "([^"]*)" are friends on FB$/ do |other_person_name|
  other_person  = Person.find_by_name(other_person_name)
  FbService.stub!(:search_fb_friends).and_return(Person.joins(:user).where('users.uid' => [other_person.user.uid]))
  FbService.stub!(:get_my_friends).and_return(Person.joins(:user).where('users.uid' => [other_person.user.uid]))
end

Given /^me and "([^"]*)" have a trust relationship$/ do |other_person_name|
  logged_person = Person.find(1)
  other_person  = Person.find_by_name(other_person_name)

  Factory(:human_network, 
          :human_id     => other_person.id, 
          :entity_id    => logged_person.id,
          :entity_type  => "Person"  )
end

Given /^I have made a trust request to "([^"]*)"$/ do |person_name|
  requested = Person.find_by_name(person_name)
  page.driver.post(network_requests_path(:trusted_person_id => requested.id))
end

Given /^"([^"]*)" and "([^"]*)" are my friends on FB$/ do |arg1, arg2|
  first_person  = Person.find_by_name(arg1)
  second_person = Person.find_by_name(arg2)
  FbService.stub!(:get_my_friends).and_return(Person.joins(:user).where('users.uid' => [first_person.user.uid, second_person.user.uid]))
  #FbService.stub!(:get_my_friends).and_return([first_person, second_person])
end

Then /^I should see "([^"]*)" and then "([^"]*)"$/ do |first_word, second_word|
  order = Regexp.new("#{first_word}.*#{second_word}", Regexp::MULTILINE)
  raise "Did not find keywords in the requested order!" unless page.body =~ order
end 
