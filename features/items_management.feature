Feature: Manage Items
   In order to share my belongings
   As a logged user
   I want to create and manage items

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
    Then I press "Save"
    And I should see "Samsung"
    And I should see "Nice mobile phone"
    And I should see "phone"

  Scenario: Adding new item for sharing
    Given I am on the new item page
    Given a person exists
    When I fill in the following:
     | Item type   | phone               |
     | Name        | Samsung             |
     | Description | Nice mobile phone   |
    And I choose "share"
    Then I press "Save"
    And I should see "Samsung"
    And I should see "Nice mobile phone"
    And I should see "phone"

  Scenario: Adding new item for gifting
    Given I am on the new item page
    When I fill in the following:
     | Item type   | phone               |
     | Name        | Samsung             |
     | Description | Nice mobile phone   |
    And I choose "share"
    Then I press "Save"
    And I should see "Samsung"
    And I should see "Nice mobile phone"
    And I should see "phone"
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
    And I should see "acknowledge trust"
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
    Then I should see "Search term not found"

   Scenario: Creating an Item without a purpose
      Given I am on the new item page
      When I fill in "Name" with "Chuchu"
      And I fill in "Item type" with "Train"
      And I press "Save"
      Then I should not have a new Item
      And I should see "prohibited this item from being saved"

   Scenario: Creating an Item with a 'Communal' purpose
      Given I am on the new item page
      When I fill in "Name" with "A nice ride"
      And I fill in "Item type" with "Bmw"
      And I choose "communal"
      And I press "Save"
      Then I should not have a new Item
      And I should see "prohibited this item from being saved"

   Scenario: Creating an Item with a 'Shareage' purpose
      Given I am on the new item page
      When I fill in "Name" with "A nice ride"
      And I fill in "Item type" with "Bmw"
      And I choose "shareage"
      And I press "Save"
      Then I should not have a new Item
      And I should see "prohibited this item from being saved"

   Scenario: Create Item without description
      Given I am on the new item page
      When I fill in "Name" with "some name"
      And I fill in "Item type" with "some type"
      And I choose "share"
      And I press "Save"
      Then a item should exist with description: ""

   Scenario: Edit item without changing it's description
      Given an item exist with description: "some description"
      And the logged person is the owner
      When I am on the edit page of that item
      And I press "Save"
      Then the item description should be "some description"

   Scenario: Showing a deleted item
      Given an item exist
      And the logged person is the owner
      And I delete that item
      When I go to the show page of that item
      Then I should not see any of the action links
      And I should see "This item has been deleted"

   Scenario: Editing a deleted item
      Given an item exist
      And the logged person is the owner
      And I delete that item
      When I go to the edit page of that item
      Then I should be on 'items'
      And I should see "That Item has been deleted!"

  Scenario: Posting new item on FB wall
    Given I am on the new item page
    Then I should see "Post this item on Facebook"
    And the "item_post_it_on_fb" checkbox should be checked

  Scenario: Edit item without changing it's description
    Given an item exist with description: "some description"
    And the logged person is the owner
    When I am on the edit page of that item
    Then I should not see "Post this item on Facebook"

  Scenario: Showing the 'Post it on fb' after failing validation
    Given I am on the new item page
    When I press "Save"
    Then I should see "Post this item on Facebook"

  @javascript
  Scenario: Show 'hidden' tag on own profile page
    Given "John" is the owner of hidden item with name "Mobile"
    Given Looking at my person page
    Then I should see "hidden"
    And I should see "Mobile"

  @javascript
  Scenario: Don't show 'hidden' tag on own profile page
    Given "John" is the owner of item with name "Mobile"
    Given Looking at my person page
    Then I should not see "hidden"
    And I should see "Mobile"
  @javascript
  Scenario: Hide one of my items
    Given "John" is the owner of item with name "Mobile"
    Given Looking at my person page
    Then I should not see "hidden"
    Then I follow "Mobile"
    And I follow "hide"
    And I should see "hidden"
