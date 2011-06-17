Feature: People network management

  As a As user who loads web page for first time
  I want to establish trusted relationship
  In order So I can share items/skills
  
  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
    Given a person exists with name: "Sebastian"
    Given a person exists with name: "Nik"
    Given a person exists with name: "Nina"
     
  Scenario: Look at persons network page
    And Looking at person page with name "Maria"
    Then I follow "Trust Profile"
    Then I should see "Trusted Network"
    And I should see "Mutual"
    And I should see "Other"
    And I should see "All"
    
  Scenario: Look at persons network page and se mutual friend
    Given "Maria" has trusted relationship with "John"
    Given "John" has trusted relationship with "Nina"
    Given "Maria" has trusted relationship with "Nina"
    Given "Maria" has trusted relationship with "Nik"
    And Looking at person page with name "Maria"
    Then I follow "Trust Profile"
    Then I follow "Mutual"
    And I should see "Nina"
     
  Scenario: Look at persons network page and se other friends
    Given "Maria" has trusted relationship with "John"
    Given "John" has trusted relationship with "Nina"
    Given "Maria" has trusted relationship with "Nina"
    Given "Maria" has trusted relationship with "Nik"
    And Looking at person page with name "Maria"
    Then I follow "Trust Profile"
     Then I follow "Others"
     And I should see "Nik"
     
  Scenario: Look at persons network page and se other friends
    Given "Maria" has trusted relationship with "John"
    Given "John" has trusted relationship with "Nina"
    Given "Maria" has trusted relationship with "Nina"
    Given "Maria" has trusted relationship with "Nik"
    And Looking at person page with name "Maria"
    Then I follow "Trust Profile"
    And I should see the words "Nik", "Nina", "John"
    
  Scenario: Look at persons network page and se other friends
    Given "Maria" has trusted relationship with "John"
    Given "John" has trusted relationship with "Nina"
    Given "Maria" has trusted relationship with "Nina"
    Given "Maria" has trusted relationship with "Nik"
    And Looking at person page with name "Maria"
    Then I follow "Trust Profile"
    And I follow "All"
    Then I should see the words "Nik", "Nina", "John"
    
  Scenario: Look at persons network page with no users
    And Looking at person page with name "Maria"
    Then I follow "Trust Profile"
    Then I should see "Trusted Network"
    And I should see "0 people in their trusted network"
    
