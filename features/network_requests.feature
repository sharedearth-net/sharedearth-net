Feature: Relationship management page
   As an user who loads web page for first time
   I want to see if I can interact with other users
   In order to create and manage relationsip
  
   Background:
      Given the user is logged in
      Given a person exists with name: "Maria"
       
   Scenario: Requests trusted relationship
      Given Looking at person page with name "Maria"
      Then I follow "trust"
      And I should see "Trust request pending"

   Scenario: Notifications of acceptance of trust request
      Given I am on "Maria"'s profile page
      And I follow "trust"
      And "Maria" accepts my trust request
      When I go to the dashboard page
      Then I should see "You have established a trusted relationship with" only once

   Scenario: Requesting a trust relationship more than once
      Given I request a trust relationship with "Maria" 2 times
      When I am on the dashboard page
      Then I should see "You are establishing a trusted relationship with"

   Scenario: Both users request a trust relationship at the same time
      Given I request a trust relationship with "Maria" 1 times
      And "Maria" request a trust relationship with me
      When I am on the dashboard page
      Then I should see "You have established a trusted relationship with"
