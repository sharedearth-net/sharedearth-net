Feature: Sending invitations

  As a As user who has admin rights
  I want to see if can send generate invitations
  In order to ivite and enable new users
  
  Background:
    Given the user is logged in
    Given invitation key exsists
    
  Scenario: I should see enter invitation code page
    Then I should see the words "Beta testing" and "Please enter your invitation code to continue, or request an invitation"
    
  Scenario: I should enter wrong invitation key
    Then I fill in "key" with "888999"
    And I press "Submit"
    Then I should see the words "The code you have provided is invalid or inactive"
    
  Scenario: When user requests invitation
    And I press "Request invitation"
    Then I should see the words "Your request for invitation has been received"

  Scenario: I should be lead to terms page when I enter the invitation
    Then I fill in active invitation
    And I press "Submit"
    Then I should see "TERMS AND CONDITIONS"

  Scenario: Regular user shouldn't have access to invitations list
    Given I am on invitations page
    And I should not see "New Invitations"
