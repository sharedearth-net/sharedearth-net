Feature: Item requests management page
  As a As user who loads web page for first time
  I want to see if can exchange items
  In order to create manage items ownership 
  
  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
    Given I am the owner of item with name "Mobile"
    And "Maria" is the owner of item with name "Bike"

   @javascript    
   Scenario: Requests item 
      Given Looking at person page with name "Maria"
      Then I follow "request"
      And I should see the words "request", "Bike"

  @javascript
  Scenario: I accept someones request for my item
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then I should see "There are no unanswered requests"
    #Then I should see the words "accepted", "collect", "complete"
    @javascript
  Scenario: I reject someones request for my item
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "reject"
    Then I should see "There are no unanswered requests"
    Then I should see "rejected"

    @javascript
  Scenario: I reject someones request for my item
    Given I requested item with name "Bike" from person with name "Maria"
    Then Looking at my person page
    And I follow "cancel"
    Then I should see "There are no unanswered requests"
    Then I should see the words "canceled"
    @javascript
  Scenario: I click on item collected for active request
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then I should see "There are no unanswered requests"
    And I am on the dashboard page
    Then I should see the words "collect", "complete"
    And I follow "collect"
    Then I should see the words "collected"
    @javascript
  Scenario: I click on item completed for active request
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then I should see "There are no unanswered requests"
    And I am on the dashboard page
    Then I should see the words "collect", "complete"
    And I follow "complete"
    Then I should see the words "Later"
    @javascript
  Scenario: I click on item completed for active request
    Given "Maria" requested item with name "Mobile" from "John"
    And Looking at my person page
    And I follow "accept"
    Then I should see "There are no unanswered requests"
    And I am on the dashboard page
    Then I should see the words "collect", "complete"
    And I follow "complete"
    Then I should see the words "Later"
    Then Looking at my person page
    And I should see "1 different people"
    @javascript
  Scenario: I click on item completed for active request
    Given "Maria" requested item with name "Mobile" from "John"
    And Looking at my person page
    And I follow "accept"
    Then I should see "There are no unanswered requests"
    And I am on the dashboard page
    And I should see "complete"
    And I follow "complete"
    And I follow "Later"
    Then Looking at my person page
    And I should see "1 different people"
    Given "Maria" requested item with name "Mobile" from "John"
    And Looking at my person page
    And I follow "accept"
    Then I should see "There are no unanswered requests"
    And I am on the dashboard page
    And I follow "complete"
    And I follow "Later"
    Then Looking at my person page
    And I should see "1 different people"
    
   Scenario: I request an item that has been deleted 
      Given an item exists with name: "Sweet ride"
      And the logged person is the owner
      And I delete that item
      When "Maria" requests that item
      Then a item request should not exist

   @javascript
   Scenario: Rejected Item Request still appear on the Dashboard
      Given "Maria" requested item with name "Mobile" from "John"
      And I am on the "dashboard" page
      When I follow "reject"
      And I wait until all Ajax requests are complete
      Then I should not see "view request"
      And I should not see "accept"
