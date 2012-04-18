Feature: Viewing someone else's trusted network and my own

  As a As user who wants to look at other profile
  I want to see if I can see people that are connected with other person
  In order So I can find new friends

  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
    Given a person exists with name: "Sebastian"
    Given a person exists with name: "Nik"
    Given a person exists with name: "Nina"
    Given I am the owner of item with name "Mobile"
    Given "Maria" is the owner of item with name "Pen"
    Given a village exists with name: "Sidney"
    Given a village exists with name: "Belgrade"
    Given "John" is part of village "Sidney"
    Given "Maria" is part of village "Sidney"
    Given "John" is part of village "Belgrade"

  Scenario: I should see the page
    And I follow "view network"
    Then I should see "Your Network"
    Then I should see "Trusted Network"


  Scenario: I should see the my friends items
    Given "John" has trusted relationship with "Maria"
    Given "John" has trusted relationship with "Nina"
    And "Maria" is the owner of item with name "Plane"
    And "Maria" is the owner of item with name "Samsung"
    And "Nina" is the owner of item with name "Baseball"
    And I follow "view network"
    And I should see "Plane"

  Scenario: I should not see items from people who are not in my network
    And "Maria" is the owner of item with name "Plane"
    And "Nina" is the owner of item with name "Baseball"
    And I follow "view network"
    And I should not see "Plane"
    And I should not see "Baseball"

  Scenario: I should see the list of villages I belong
    And I follow "view network"
    Then I should see "Sidney"
    And I should see "Belgrade"

    @javascript
  Scenario: I should see the list of my items only
    Then I follow "view network"
    And I should see "Mobile"
    And I should see "Pen"

    @javascript
  Scenario: I should see the list of items belong to specific group only
    Then I follow "view network"
    Then I follow "Belgrade"
    And I should see "Mobile"
    And I should not see "Pen"

  Scenario: I should see the list of items belong to specific group only not the other
    Then I follow "view network"
    Then I follow "Sidney"
    And I should see "Mobile"
    And I should see "Pen"

  Scenario:Check if there are duplicated items
    Then I should see there are no duplicated items
