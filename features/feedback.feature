Feature: Leaving feedback

  As a As user who loads web page for first time
  I want to see if feedback can be left
  In order to complete full item request
  
  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
    Given I am the owner of item with name "Mobile"
    And "Maria" is the owner of item with name "Bike"
    
  Scenario: I leave positive feedback
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then I should see the words "accepted", "collect", "complete"
    And I follow "complete"
    Then I choose "positive"
    And press "Submit"
    Then I should see "show feedback"
    
  Scenario: I leave neutral feedback
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then I should see the words "accepted", "collect", "complete"
    And I follow "complete"
    Then I choose "neutral"
    Then I should see "What happened?"
     When I fill in the following:
     | note   | My neutral opinion |
    And press "Submit"
    Then I should see "show feedback"
    
  Scenario: I leave negative feedback
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then I should see the words "accepted", "collect", "complete"
    And I follow "complete"
    Then I choose "negative"
    Then I should see "What happened?"
     When I fill in the following:
     | note   | My negative opinion |
    And press "Submit"
    Then I should see "show feedback"
    
    
    
    
