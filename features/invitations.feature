Feature: Sending invitations

  As a As user who has admin rights
  I want to see if can send generate invitations
  In order to ivite and enable new users
  
  Background:
    Given the user is logged in
    Given I am on invitations page
    
  Scenario: Regular user shouldn't have access to invitations list
    And I should not see "New Invitations"
