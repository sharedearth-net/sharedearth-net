Feature: Relationship management page

  As a As user who loads web page for first time
  I want to see if can interact with other user
  In order to create manage relationsip
  
  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
    
  Scenario: Requests trusted relationship
    Given Looking at person page with name "Maria"
    Then I follow "establish trust"
    And I should see "Created request to establish trusted relationship."
    
    

