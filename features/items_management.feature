Feature: Items management page

  As a As user who loads web page for first time
  I want to see if item can be manipulated
  In order So I can manipulate my items
  
  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
  
  Scenario: Adding new item for gifting
    Given I am on the new item page
    When I fill in the following:
     | Item type   | phone               |
     | Name        | Samsung             |
     | Description | Nice mobile phone   |
    And I choose "share"
    Then I press "Create Item"
    And I should see "Item was successfully created."
  
  Scenario: Adding new item for sharing
    Given I am on the new item page
    Given a person exists
    When I fill in the following:
     | Item type   | phone               |
     | Name        | Samsung             |
     | Description | Nice mobile phone   |
    And I choose "share"
    Then I press "Create Item"
    And I should see "Item was successfully created." 
    
  Scenario: Adding new item for gifting
    Given I am on the new item page
    When I fill in the following:
     | Item type   | phone               |
     | Name        | Samsung             |
     | Description | Nice mobile phone   |
    And I choose "share"
    Then I press "Create Item"
    And I should see "Item was successfully created."
    And Looking at person page with name "John"
    Then I follow "view item"
    And I should see "Samsung"
    
  Scenario: Item is searched and found record in trusted network
    Given "Maria" has trusted relationship with "John"
    And "Maria" is the owner of item with name "Mountainbike"
    And "Maria" is the owner of item with name "Plane"
    And Looking at person page with name "Maria"
    And I should see "withdraw trust"
    Then I should see "bike"
    When I fill in "search" with "bike"
    Then I press "Search" 
    And I should see "bike"
    And I should see "Mountainbike"
    Then I should see "view item"
    And I should see "From your trusted network"
    
  Scenario: Item is searched and found record in extended network
    Given "Maria" has trusted relationship with "John"
    And "Maria" is the owner of item with name "Plane"
    Given a person exists with name: "Nick"
    And "Nick" is the owner of item with name "Mobile"
    Given "Maria" has trusted relationship with "Nick"
    And Looking at person page with name "Nick"
    And I should see "establish trust"
    Then I should see "Mobile"
    When I fill in "search" with "Mobile"
    Then I press "Search" 
    And I should not see "Mobile"
    Then I should not see "view item"
    And I should not see "From your extended network"
    
  Scenario: Item is searched but it belongs to someone that is not in my trusted nor extended network
    And "Maria" is the owner of item with name "Bike"
    And Looking at person page with name "Maria"
    Then I should see "Bike"
    When I fill in "search" with "Bike"
    Then I press "Search" 
    Then I should see "Sorry, nothing matches your search criteria"
    
   
      
    
