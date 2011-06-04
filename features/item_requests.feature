Feature: Item requests management page

  As a As user who loads web page for first time
  I want to see if can exchange items
  In order to create manage items ownership 
  
  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
    Given I am the owner of item with name "Mobile"
    And "Maria" is the owner of item with name "Bike"
    
  Scenario: Requests item 
    Given Looking at person page with name "Maria"
    Then I follow "request"
    And I should see the words "successfully", "Bike"
    
  Scenario: I accept someones request for my item
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then I should see the words "accepted", "collect", "complete"
    
  Scenario: I reject someones request for my item
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "reject"
    Then I should see the words "rejected"
    
  Scenario: I reject someones request for my item
    Given I requested item with name "Bike" from person with name "Maria"
    Then Looking at my person page
    And I follow "cancel"
    Then I should see the words "canceled"
    
  Scenario: I click on item collected for active request
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then I should see the words "accepted", "collect", "complete"
    And I follow "collect"
    Then I should see the words "collected"
    
  Scenario: I click on item completed for active request
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then I should see the words "accepted", "collect", "complete"
    And I follow "complete"
    Then I should see the words "Later"
    
  Scenario: I click on item completed for active request
    Given "Maria" requested item with name "Mobile" from "John"
    And Looking at my person page
    And I follow "accept"
    And I should see the words "accepted", "collect", "complete"
    And I follow "complete"
    And I follow "Later"
    Then Looking at my person page
    And I should see "1 different people"
    
  Scenario: I click on item completed for active request
    Given "Maria" requested item with name "Mobile" from "John"
    And Looking at my person page
    And I follow "accept"
    And I should see the words "accepted", "collect", "complete"
    And I follow "complete"
    And I follow "Later"
    Then Looking at my person page
    And I should see "1 different people"
    Given "Maria" requested item with name "Mobile" from "John"
    And Looking at my person page
    And I follow "accept"
    And I should see the words "accepted", "collect", "complete"
    And I follow "complete"
    And I follow "Later"
    Then Looking at my person page
    And I should see "1 different people"
    
    
    
      
    
    
