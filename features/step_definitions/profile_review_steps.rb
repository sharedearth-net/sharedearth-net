Given /^(.+) logs in$/ do |person_model|
  person = model(person_model)
  person.authorise!
  omniauth_mock_facebook_with_uid(person.user.uid)
  visit "/auth/facebook"
end

Given /^(.+) has reviewed its profile$/ do |person_model|
  person = model(person_model)
  person.has_reviewed_profile = true
  person.save!
end

When /^that person accepts all terms and conditions$/ do
  click_link "Accept"
  click_link "Accept"
  click_button "Connect"  
end

When /^I lol$/ do
  raise current_url
end

Then /^I should be at (.+) profile page$/ do |person_model|
  person = model(person_model)
  current_url.should match edit_person_url(person)
end
