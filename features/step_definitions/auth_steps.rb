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
  omniauth_mock_facebook
  visit "/auth/facebook"
end

