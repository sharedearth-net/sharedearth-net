Feature: Leaving comment to everything

  As a As common user
  I want to see if reputation rating is showing properly
  In order to manipulate reputation rating
  #Main user is John
  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
    Given "John" is the owner of item with name "Mobile"
    And "Maria" is the owner of item with name "Bike"
    When "Maria" requested item with name "Mobile" from "John"
    And I follow "home"

  Scenario: Showing no comment add link
    Then I should not see "Add comment"
  @javascript
  Scenario: Add comment on current request don't create recent activity
    When I fill in the following:
     | comment   | My comment opinion |
    And I submit the comment
    #    And I wait until all Ajax requests are complete
    Then I should not see "commented on the request"
  @javascript
  Scenario: Add comment on current request
    When I fill in the following:
     | comment   | My comment opinion |
    And I submit the comment
    #And I wait until all Ajax requests are complete
    Then I should see "My comment opinion"

  @javascript
  Scenario: Showing add comment on item request, leaving comment
    Then I follow "view request"
    When I fill in the following:
     | comment   | My comment opinion |
    And I submit the comment
    And I wait until all Ajax requests are complete
    Then I should see "My comment opinion"
    @javascript
  Scenario: Commenting event log
    And Looking at my person page
    And I should see "accept"
    And I follow "accept"
    And I should see "There are no unanswered requests"
    Then I am on the dashboard page
    And I follow "complete"
    And I should see "Later"
    And I follow "Later"
    And I follow "home"
    And I should see "comments(0)"
    When I fill in the following:
     | comment   | My comment opinion |
    And I submit the comment
    And I wait until all Ajax requests are complete
    Then I should see "My comment opinion"
    And I should see "comments(1)"
    @javascript
  Scenario: Commenting event with public comment
    Then I follow "view request"
    When I fill in the following:
     | comment   | My request opinion |
     And press "Add comment"
    Then I should see "My request opinion"
    And Looking at my person page
    And I follow "accept"
    And I should see "There are no unanswered requests"
    Then I am on the dashboard page
    And I follow "complete"
    And I follow "Later"
    And I follow "home"
    When I fill in the following:
     | comment   | My public opinion |
    And I submit the comment
    And I wait until all Ajax requests are complete
    Then I should see "My public opinion"
    And I should see "comments(1)"
    Then I follow "leave feedback"
    And I follow "Later"
    Then I should see "My public opinion"
    Then I should see "My request opinion"

