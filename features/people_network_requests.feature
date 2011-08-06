Feature: Relationship management page
   As an user who loads web page for first time
   I want to see if I can interact with other users
   In order to create and manage relationsip
  
   Background:
      Given the user is logged in
      Given a person exists with name: "Maria"
       
   Scenario: Requests trusted relationship
      Given Looking at person page with name "Maria"
      Then I follow "establish trust"
      And I should see "Establish trust request pending"

   @last_test
   Scenario: Notifications of acceptance of trust request
      Given I am on "Maria"'s profile page
      And I follow "establish trust"
      And "Maria" accepts my trust request
      When I go to the dashboard page
      Then I should see "You have established a trusted relationship with" only once
