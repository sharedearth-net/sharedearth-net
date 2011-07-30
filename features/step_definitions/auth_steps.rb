Given /^I am signed in$/ do  
  visit login_path
  visit oauth_callback_path
end  

When /^Facebook authorizes me$/ do
  visit oauth_callback_path
end

#I am signed in with provider "Facebook"
Given /^I am signed in with provider "([^"]*)"$/ do |provider|
  visit "/auth/#{provider.downcase}"
end

Given /^the user is logged in$/ do
  person = Factory(:person)
  person.authorise!
  person.accept_tc!
  person.accept_tr!
  person.accept_pp!
  omniauth_mock_facebook_with_uid(person.user.uid)
  visit "/auth/facebook"
end

Given /^the unauthorised user is logged in$/ do
  omniauth_mock_facebook
  visit "/auth/facebook"
end

Given /^the unaccepted user is logged in$/ do
  person = Factory(:person)
  person.authorise!
  omniauth_mock_facebook_with_uid(person.user.uid)
  visit "/auth/facebook"
end

Given /^the invitation system is on$/ do
  Settings.invitations = 'true'
end

