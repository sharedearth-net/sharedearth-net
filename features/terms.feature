Feature: Accepting terms
   As an user who is in registration process
   I want to accept the terms
   In order to enter the website

   Background:
      Given the invitation system is on
      Given the unauthorised user is logged in
      Given invitation key exsists
   @javascript
   Scenario: I should see enter invitation code page
      Then I should see the words "Welcome", "Enter your invitation code to continue" and "sharedearth.net is now in private beta"
   @javascript
   Scenario: I should be lead to terms page when I enter the invitation
      Then I fill in active invitation
      And I press "Submit"
      Then I should see "Legal Notices"
      And I should not see link with text "back"
      And I should not see link with text "disconnect"
   @javascript
   Scenario: I should be able to decline terms
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "Legal Notices"
      And I should not see link with text "back"
      And I should not see link with text "disconnect"
      Then I follow "Reject"
      Then I should see "connect"

   Scenario: I should be able to decline principles
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "Legal Notices"
      When I follow "Accept"
      Then I should see "Design Principles"
      When I follow "No thanks"
      Then I should see "connect"


  Scenario: I should be able to accept transparency
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "Legal Notices"
      And I follow "Accept"
      Then I should see "Design Principles"
   @javascript
   Scenario: I should be able to accept principles and use
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "Legal Notices"
      When I follow "Accept"
      Then I should see "Design Principles"
      And I should not see link with text "back"
      And I should not see link with text "disconnect"
      Then I uncheck "facebook"
      And I press "Connect"
      Then I should see the words "Edit Profile"

   Scenario: I should be able to decline terms, and get back to the same page
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "Legal Notices"
      Then I follow "Reject"
      Then I should see "connect"

@javascript
   Scenario: User has accepted Terms and Transparency but not the Principles
      Given the logged person has accepted legal notice but not principles
      Then I fill in active invitation
      And I press "Submit"
      Then I should see "Design Principles"
      When I uncheck "facebook"
      And I press "Connect"
      Then I should be on the dashboard page

   Scenario: User has accepted all terms and conditions
      Given the logged person has accepted all terms and conditions
      Then I fill in active invitation
      And I press "Submit"
      Then I should be on the dashboard page

   Scenario: User should not see the logo, name and toolbar on the Terms page
      Then I fill in active invitation
      And I press "Submit"
      And I should not see the header

   Scenario: User should not see the logo, name and toolbar on the Principles page
      Then I fill in active invitation
      And I press "Submit"
      When I follow "Accept"
      And I should not see the header
