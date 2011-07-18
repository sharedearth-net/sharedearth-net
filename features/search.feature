Feature: Searching for items and people

  As a As user who has items and relationship with other users
  I want to see if search can be performed
  In order So I find item to request
  
  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
    Given a person exists with name: "Sebastian"
    
  Scenario: Item is searched and found record in trusted network and showing only item
    Given "Maria" has trusted relationship with "John"
    And "Maria" is the owner of item with name "Plane"
    When I fill in "search" with "Plane"
    Then I press "Search" 
    And I should see "Plane"
    Then I should see "view item"
    And I should see "From your trusted network"
    
  Scenario: Person is searched and found, but no item is showed
    Given "Maria" has trusted relationship with "John"
    And "Maria" is the owner of item with name "Plane"
    Then I should see "disconnect"
    When I fill in "search" with "Maria"
    Then I press "Search" 
    And I should see "From your trusted network"
    And I should see "Maria"
    And I should not see "Plane"
    Then I should not see "view item"
    
  Scenario: Person is searched and found, but no item is showed
    Given "Maria" has trusted relationship with "John"
    When I fill in "search" with "Plane"
    Then I press "Search" 
    And I should see "Search term not found"
    
    
  Scenario: Generic search and found item and person, but showing only item
    Given "Maria" has trusted relationship with "John"
    And "Maria" is the owner of item with name "Marine soldier"
    When I fill in "search" with "Mari"
    Then I press "Search" 
    And I should see "From your trusted network"
    And I should see "Marine soldier"
    Then I should see "view item"
          #One time is for result and other for search term
    Then I should see "Maria" 2 times
    
  Scenario: Generic search and found item and person, but showing only item
    Given "Maria" has trusted relationship with "John"
    And "Maria" is the owner of item with name "Marine soldier"
    When I fill in "search" with "Mari"
    Then I press "Search" 
    And I should see "From your trusted network"
    And I should see "Marine soldier"
    Then I should see "view item"
    Then I should see "Maria" 2 times
    Then I follow "All Results"
    And I should see "Marine soldier"
    Then I should see "view item"
       #One time is for item result, 2nd for search term, and 3rd for people result
    Then I should see "Maria" 3 times
    
  Scenario: Two users, who are not in a relationship search for each other
    When I fill in "search" with "aria"
    Then I press "Search" 
    And I should see "From your trusted network"
    And I should see "Maria"
    
    
