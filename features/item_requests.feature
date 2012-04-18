Feature: Item requests management page
  As a As user who loads web page for first time
  I want to see if can exchange items
  In order to create manage items ownership

  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
		Given a person exists with name: "Bach"
    Given I am the owner of item with name "Mobile"
    Given I am the owner of shareage item with name "Pen"
    Given I am the owner of gift item with name "Chair"
    Given "Maria" is the owner of shareage item with name "BMX"
    And "Maria" is the owner of item with name "Bike"

   @javascript
   Scenario: Requests item
      Given Looking at person page with name "Maria"
      Then I follow "request"
      And I should see the words "request", "bike"

  @javascript
  Scenario: I accept someones request for my item
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then Looking at my person page
    Then I should see "There are no unanswered requests"

  @javascript
  Scenario: I reject someones request for my item
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "reject"
    Then Looking at my person page
    Then I should see "There are no unanswered requests"

  @javascript
  Scenario: I reject someones request for my item
    Given I requested item with name "Bike" from person with name "Maria"
    Then Looking at my person page
    And I follow "cancel"
    Then Looking at my person page
    Then I should see "There are no unanswered requests"

    @javascript
  Scenario: I click on item collected for active request
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then Looking at my person page
    Then I should see "There are no unanswered requests"
    And I am on the dashboard page
    Then I should see the words "collect", "complete"
    And I follow "collect"
    Then I should see the words "collected"

    @javascript
  Scenario: I click on item collected for active request for gift item
    Given "Maria" requested item with name "Chair" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then Looking at my person page
    Then I should see "There are no unanswered requests"
    And I am on the dashboard page
    Then I should see the words "collected"
    And I follow "collected"
    And I wait until all Ajax requests are complete
    Then I should not see "Something"

    @javascript
  Scenario: I click on item completed for active request
    Given "Maria" requested item with name "Mobile" from "John"
    Then Looking at my person page
    And I follow "accept"
    Then Looking at my person page
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
    And Looking at my person page
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
    And Looking at my person page
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
    And Looking at my person page
    Then I should see "There are no unanswered requests"
    And I am on the dashboard page
    And I follow "complete"
    And I follow "Later"
    Then Looking at my person page
    And I should see "1 different people"
@javascript
   Scenario: I request an item that has been deleted
    Given Looking at Maria's item with name "Bike"
    Given "Maria" deletes item "Bike"
    Then I follow "Request"
    Then I should see "not"
    Then a item request should not exist

   @javascript
   Scenario: Rejected Item Request still appear on the Dashboard
      Given "Maria" requested item with name "Mobile" from "John"
      And I am on the "dashboard" page
      When I follow "reject"
      And I wait until all Ajax requests are complete
      Then I should not see "view request"
      And I should not see "accept"

   @javascript
   Scenario: Looking at own completed item request page
      Given Person with name "John" has completed request with "Maria"
      And I am looking at last request page
      Then I should see "John shared their bike with Maria"

   @javascript
   Scenario: Looking at other completed item request page
      Given Person with name "Bach" has accepted request with "Maria"
      And I am looking at last request page
      Then I should see "Recent Activity"

   @javascript
   Scenario: Looking at other completed item request page, don't see private comments
      Given Person with name "Bach" has completed request with "Maria"
			Given "Bach" left comment "Nice" for last request
      And I am looking at last request page
      Then I should not see "Nice"

   @javascript
   Scenario: Looking at other completed item request page, don't see private comments
      Given Person with name "Bach" has completed request with "Maria"
			Given "John" left comment "Nice" for last request
      And I am looking at last request page
      Then I should not see "Nice"

   @javascript
   Scenario: Looking at other completed item request page, don't see private comments
      Given Person with name "John" has completed request with "Maria"
			Given "John" left comment "Nice" for last request
      And I am looking at last request page
      Then I should see "Nice"

   #Shareage requests features
   #Shareage stage 1
 @javascript
  Scenario: Action Sentence from gifter perspective stage 1
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      Then I should see "Maria is requesting your bike for shareage"
  @javascript
  Scenario: Action Sentence from requester perspective stage 1
      Given "John" requested item with name "BMX" from "Maria"
      And I am on the "dashboard" page
      Then I should see "You are requesting Maria's bike for shareage"
@javascript
  Scenario: Action links from gifter perspective stage 1
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      Then I should see the words "accept", "reject", "view request", "comments(0)"

  Scenario: Action Sentence from requester perspective stage 1
      Given "John" requested item with name "BMX" from "Maria"
      And I am on the "dashboard" page
      Then I should see the words "cancel", "view request", "comments(0)"
@javascript
  Scenario: Recent activity Sentence from gifter perspective stage 1
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      Then I should see "Maria requested your bike for shareage"
@javascript
  Scenario: Recent activity Sentence from requester perspective stage 1
      Given "John" requested item with name "BMX" from "Maria"
      And I am on the "dashboard" page
      Then I should see "You requested Maria's bike for shareage"

   #Shareage stage 2 - to be continued
   @javascript
   Scenario: Rejected Item Request still appear on the Dashboard
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      When I follow "reject"
      And I wait until all Ajax requests are complete
      Then I should not see "view action"
      And I should not see "accept"

   #Shareage stage 1 check sentences for request and recent activity 4 tests
   @javascript
   Scenario: Show request sentence when shareage item is requested - gifter
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      Then I should see "Maria is requesting your bike for shareage"

   @javascript
   Scenario: Show request sentence when shareage item is requested - gifter
      Given "Maria" requested item with name "Pen" from "John"
      And I am looking at last request page
      Then I should see "Maria is requesting your bike for shareage"

   @javascript
   Scenario: Show request activity sentence when shareage item is requested - gifter
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      Then I should see "Maria requested your bike for shareage"

   @javascript
   Scenario: Show request sentence when shareage item is requested - requested
      Given "John" requested item with name "BMX" from "Maria"
      And I am on the "dashboard" page
      Then I should see "You are requesting Maria's bike for shareage"

   @javascript
   Scenario: Show request activity sentence when shareage item i  requested - requester
      Given "John" requested item with name "BMX" from "Maria"
      And I am on the "dashboard" page
      Then I should see "You are requesting Maria's bike for shareage"

   @javascript
   Scenario: Show request activity sentence when shareage item i  requested - requester
      Given "John" requested item with name "BMX" from "Maria"
      And I am looking at last request page
      Then I should see "You are requesting Maria's bike for shareage"

   #Shareage stage 2 check sentences for request and recent activity 4 tests
   @javascript
   Scenario: Show request sentence when shareage item is requested - gifter
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      And I follow "accept"
      Then I should see "Awaiting collection of your bike by Maria"

   @javascript
   Scenario: Show request activity sentence when shareage item is requested - gifter
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      And I follow "accept"
      Then I should see "Awaiting collection of your bike by Maria"

   #Shareage stage 3 check sentences for request and recent activity 4 tests - not finished
   @javascript
   Scenario: Show request sentence when shareage item is requested - gifter
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      And I follow "accept"
      Then I should see "Awaiting collection of your bike by Maria"

   @javascript
   Scenario: Show request activity sentence when shareage item is requested - gifter
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      And I follow "accept"
      Then I should see "Awaiting collection of your bike by Maria"

   @javascript
   Scenario: Show request sentence when shareage item is requested - requested
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      And I follow "accept"
      Then I should see "Awaiting collection of your bike by Maria"

   @javascript
   Scenario: Show request activity sentence when shareage item i  requested - requester
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      And I follow "accept"
      Then I should see "You accepted Maria's request for your bike"

   @javascript
   Scenario: Show request activity sentence when shareage item i  requested - requester
      Given "John" requested item with name "BMX" from "Maria"
      And I am looking at last request page
      Then I should see "You are requesting Maria's bike for shareage"
      #Shareage stage 2 tests
   @javascript
   Scenario: Accepted shareage Item Request shows new actions on dashboard
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      When I follow "accept"
      And I wait until all Ajax requests are complete
      Then I should see "view action"
      And I should see "collected"
      And I should not see "completed"

   @javascript
   Scenario: Accepted shareage Item Request shows action sentence on dashboard
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      When I follow "accept"
      And I wait until all Ajax requests are complete
      Then I should see "Awaiting collection of your pen by Maria"

   @javascript
   Scenario: Accepted shareage Item Request makes item hidden
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      When I follow "accept"
      And I wait until all Ajax requests are complete
      Then I should see "view action"
      And Looking at my person page
      Then I should see "hidden"

   @javascript
   Scenario: Shareage state Item actions on dashboard
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      When I follow "accept"
      And I wait until all Ajax requests are complete
      Then I should see "view action"
      And I should see "collected"
      And I should not see "completed"
      When I follow "collected"
      Then I should not see "view action"
      Then I follow "manage"
      And I should see "recall item"

   @javascript
   Scenario: Shareage state Item actions on dashboard
      Given "Maria" requested item with name "Pen" from "John"
      And I am on the "dashboard" page
      When I follow "accept"
      And I wait until all Ajax requests are complete
      Then I should see "view action"
      And I should see "collected"
      And I should not see "completed"
      When I follow "collected"
      Then I should not see "view action"
      Then I follow "manage"
      And I should see "recall item"
      When I follow "recall item"
      Then I should see "cancel recall"
