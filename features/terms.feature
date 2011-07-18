Feature: Accepting terms

  As a As user who is in registration process
  I want to see if a user must accept terms
  In order to enter the website
  
  Background:
    Given the invitation system is on
    Given the unauthorised user is logged in
    Given invitation key exsists
    
  Scenario: I should see enter invitation code page
    Then I should see the words "Welcome", "Enter your invitation code to continue" and "sharedearth.net is now in private beta"
    
  Scenario: I should be lead to terms page when I enter the invitation
    Then I fill in active invitation
    And I press "Submit"
    Then I should see "TERMS AND CONDITIONS"

  Scenario: I should be able to decline terms
    Then I fill in active invitation
    And I press "Submit"
    Then I should see the words "TERMS AND CONDITIONS"
    Then I follow "Reject"
    Then I should see the words "Welcome" and "Connect"

  Scenario: I should be able to accept terms
    Then I fill in active invitation
    And I press "Submit"
    Then I should see the words "TERMS AND CONDITIONS"
    When I follow "Accept"
    Then I should see "Important Information about sharedearth.net"
    
  Scenario: I should be able to decline principles 
    Then I fill in active invitation
    And I press "Submit"
    Then I should see the words "TERMS AND CONDITIONS"
    When I follow "Accept"
    Then I should see "Important Information about sharedearth.net"
    When I follow "No thanks"
    Then I should see the words "Welcome" and "Connect"
    
  Scenario: I should be able to accept principles and use
    Then I fill in active invitation
    And I press "Submit"
    Then I should see the words "TERMS AND CONDITIONS"
    When I follow "Accept"
    Then I should see "Important Information about sharedearth.net"
    And I follow "Connect"
    Then I should see the words "Edit Profile"
    
  Scenario: I should be able to decline terms, and get beck to same page
    Then I fill in active invitation
    And I press "Submit"
    Then I should see the words "TERMS AND CONDITIONS"
    Then I follow "Reject"
    Then I should see the words "Welcome" and "Connect"
    
    
