Given /^"([^"]*)" accepts my trust request$/ do |person_name|
  PeopleNetworkRequest.last.confirm!
end

Then /^I should see "([^"]*)" only once$/ do |expression|
  page.has_css?('p', :text => expression, :count => 1).should be_true
end

Given /^I request a trust relationship with "([^"]*)" (\d+) times$/ do |person_name, times|
  person = Person.find_by_name(person_name) 
  request_url = "/people_network_requests?trusted_person_id=#{person.id}"
  times.to_i.times { page.driver.post(request_url) }
end

# This is, pretty yucky, but at least it works
Given /^"([^"]*)" request a trust relationship with me$/ do |person_name|
  requester_user = Person.find_by_name(person_name).user
  omniauth_mock_facebook_with_uid(requester_user.uid)
  visit "/auth/facebook"

  logged_person = Person.find_by_id(1)
  request_url   = "/people_network_requests?trusted_person_id=#{logged_person.id}"
  page.driver.post(request_url)
end
