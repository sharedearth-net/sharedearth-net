Feature: Sending invitations

  As a As user who has admin rights
  I want to see if can send generate invitations
  In order to ivite and enable new users
  
  Background:
    Given the user is logged in
    Given I am on ivitations page
    
  Scenario: Admin generates one ivitation
    And I should see "Invitation generated"
