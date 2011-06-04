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
  steps %Q{
    Given I am on the home page
    Then I should see "Connect"
    And I follow "Connect"
    Then I should see "News"
    }
end

