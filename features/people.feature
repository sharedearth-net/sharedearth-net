Feature: Items management page

  As a As user who loads web page for first time
  I want to see if I can find persons
  In order So I can manipulate communicate with them

  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
    Given "Maria" has trusted relationship with "John"

  Scenario: Searching for person - no items found
    When I fill in "search" with "Maria"
    Then I press "Search"
    And I should not see "Bikemaria"
    And I should see "Maria"

  Scenario: Searching for person, some items found
    And "Maria" is the owner of item with name "Mountain"
    When I fill in "search" with "Mountain"
    Then I press "Search"
    And I should see "Mountain"
    And I follow "People"
    And I should not see "Maria"

