Given /^I am signed in$/ do  
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
  FbService.stub!(:fb_logout_url).and_return(dashboard_path)

  person = Factory(:person, :id => 1)
  person.authorise!
  person.accept_tc!
  person.accept_tr!
  person.accept_pp!
  person.reviewed_profile!
  omniauth_mock_facebook_with_uid(person.user.uid)
  visit "/auth/facebook"

  FbService.stub!(:post_on_my_wall).and_return(true)
end

Given /^the unauthorised user is logged in$/ do
  FbService.stub!(:fb_logout_url).and_return(dashboard_path)
  person = Factory(:person, :id => 1, :authorised_account => false, :accepted_tc => false, :accepted_pp => false, :accepted_tr => false )
  omniauth_mock_facebook_with_uid(person.user.uid)
  visit "/auth/facebook"
end

Given /^the authorised user is logged in$/ do
  FbService.stub!(:fb_logout_url).and_return(dashboard_path)
  person = Factory(:person, :id => 1, :accepted_tc => false, :accepted_pp => false, :accepted_tr => false )
  omniauth_mock_facebook_with_uid(person.user.uid)
  visit "/auth/facebook"
end

Given /^the authorised user is first time logged in$/ do
  FbService.stub!(:fb_logout_url).and_return(dashboard_path)
  person = Factory(:person, :id => 1, :has_reviewed_profile => false, :accepted_pp => false )
  omniauth_mock_facebook_with_uid(person.user.uid)
  visit "/auth/facebook"
end

Given /^the unaccepted user is logged in$/ do
  FbService.stub!(:fb_logout_url).and_return(dashboard_path)

  person = Factory(:person)
  person.authorise!
  omniauth_mock_facebook_with_uid(person.user.uid)
  visit "/auth/facebook"
end

Given /^the invitation system is on$/ do
  Settings.invitations = 'true'
end

Given /^the invitation system is off$/ do
  Settings.invitations = 'false'
end

Given /^the user accepts all terms$/ do
  steps %Q{
    When I follow "Accept"
    When I uncheck "facebook"
    And I press "Connect"
  }
end
