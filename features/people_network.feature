Feature: People network management

  As a As user who loads web page for first time
  I want to establish trusted relationship
  In order So I can share items/skills
 
@omniauth_test       
  Scenario: Item is searched
  Given the user is logged in
    Given a person exists with name: "Maria"
    Given "Maria" has trusted relationship with "John"
    And Looking at person page with name "Maria"
    Then I should see "withdraw trust"
