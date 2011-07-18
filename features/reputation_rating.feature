Feature: Leaving feedback affects reputation

  As a As user who loads web page for first time
  I want to see if reputation rating is showing properly
  In order to manipulate reputation rating
  #Main user is John
  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
    Given "John" is the owner of item with name "Mobile"
    And "Maria" is the owner of item with name "Bike"
    
  Scenario: Showing n/a repuation
    Then I should see the words "n/a", "0"
    
  Scenario: Reputation is not affected if only one party posted feedback
    When "Maria" requested item with name "Mobile" from "John"
    And Looking at person page with name "John"
    And I follow "accept"
    And I am on the dashboard page
    And I follow "complete"
    Then I choose "negative"
    When I fill in the following:
     | note   | My negative opinion |
    And press "Submit"
    Then I should see "show feedback"
    Then I follow "show feedback"
    And I should not see "My negative opinion"
    
  Scenario: Feedback created both parties, one is negative
    When Person with name "Maria" has completed request with "John"
    Given Person with name "Maria" left positive feedback for last request
    Given Person with name "John" left negative feedback for last request
    And I am looking at last request page
    And I should see "Negative opinion"
    And I should not see "Neutral opinion"
  
   Scenario: Feedback created both parties, one is negative, one is neutral
    When Person with name "Maria" has completed request with "John"
    Given Person with name "Maria" left negative feedback for last request
    Given Person with name "John" left neutral feedback for last request
    And I am looking at last request page
    And I should see "Negative opinion"
    And I should see "Neutral opinion"
    
   Scenario: Feedback created by one party only
    When Person with name "Maria" has completed request with "John"
    Given Person with name "John" left negative feedback for last request
    And I am looking at last request page
    And I should not see "Negative opinion"
    
  Scenario: Feedback created both parties, one is positive, one is neutral, reputation changes
    When Person with name "Maria" has completed request with "John"
    Given Person with name "Maria" left positive feedback for last request
    Given Person with name "John" left neutral feedback for last request
    And Looking at person page with name "John"
    Then I should see "100%" in css class "trust-box-holder"
    And Looking at person page with name "Maria"
    Then I should see "0%" in css class "trust-box-holder"
    And I should not see "n/a"
    
  Scenario: Feedback created both parties, one is positive, one is negative, reputation changes
    When Person with name "Maria" has completed request with "John"
    Given Person with name "Maria" left positive feedback for last request
    Given Person with name "John" left negative feedback for last request
    And Looking at person page with name "John"
    Then I should see "100%" in css class "trust-box-holder"
    Then I should not see "n/a" in css class "trust-box-holder"
    And Looking at person page with name "Maria"
    Then I should see "0%" in css class "trust-box-holder"
    Then I should not see "n/a" in css class "trust-box-holder"
    
  Scenario: Number of distinct people increase
    Given "Maria" requested item with name "Mobile" from "John"
    And Looking at my person page
    And I follow "accept"
    And I am on the dashboard page
    And I follow "complete"
    And I follow "Later"
    Then Looking at my person page
    And I should see "1 different people" in css class "trust-box-holder"

