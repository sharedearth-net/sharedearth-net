Feature: Accepting terms
   As an user who is in registration process
   I want to accept the terms
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
      Then I should see "connect"

   Scenario: I should be able to accept terms
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "TERMS AND CONDITIONS"
      When I follow "Accept"
      Then I should see "Transparency Policy"
    
   Scenario: I should be able to decline principles 
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "TERMS AND CONDITIONS"
      When I follow "Accept"
      Then I should see "Transparency Policy"
      And I follow "Accept"
      Then I should see "DESIGN PRINCIPLES"
      When I follow "No thanks"
      Then I should see "connect"
    
   Scenario: I should be able to decline transparency 
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "TERMS AND CONDITIONS"
      When I follow "Accept"
      Then I should see "Transparency Policy"
      When I follow "Reject"
      Then I should see "connect"
    
  Scenario: I should be able to accept transparency
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "TERMS AND CONDITIONS"
      When I follow "Accept"
      Then I should see "Transparency Policy"
      And I follow "Accept"
      Then I should see "DESIGN PRINCIPLES"
    
   Scenario: I should be able to accept principles and use
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "TERMS AND CONDITIONS"
      When I follow "Accept"
      Then I should see "Transparency Policy"
      And I follow "Accept"
      Then I should see "DESIGN PRINCIPLES"
      And I follow "Connect"
      Then I should see the words "Edit Profile"
    
   Scenario: I should be able to decline terms, and get back to the same page
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "TERMS AND CONDITIONS"
      Then I follow "Reject"
      Then I should see "connect"

   Scenario: User has accepted Terms but not Transparency nor Principles
      Given the logged person has accepted terms but not transparency nor principles
      Then I fill in active invitation
      And I press "Submit"
      Then I should see "Transparency Policy"
      And I follow "Accept"
      Then I should see "DESIGN PRINCIPLES"
      And I follow "Connect"
      Then I should be on the dashboard page

   Scenario: User has accepted Terms and Transparency but not the Principles
      Given the logged person has accepted terms and transparency but not principles
      Then I fill in active invitation
      And I press "Submit"
      Then I should see "DESIGN PRINCIPLES"
      And I follow "Connect"
      Then I should be on the dashboard page

   Scenario: User has accepted Transparency and Principles but not Terms
      Given the logged person has accepted transparency and principles but not terms
      Then I fill in active invitation
      And I press "Submit"
      Then I should see the words "TERMS AND CONDITIONS"
      When I follow "Accept"
      Then I should be on the dashboard page

   Scenario: User has accepted Terms and Principles but not Transparency
      Given the logged person has accepted terms and principles but not transparency
      Then I fill in active invitation
      And I press "Submit"
      Then I should see "Transparency Policy"
      And I follow "Accept"
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

   Scenario: User should not see the logo, name and toolbar on the Transparency page
      Then I fill in active invitation
      And I press "Submit"
      When I follow "Accept"
      And I should not see the header

   Scenario: User should not see the logo, name and toolbar on the Principles page
      Then I fill in active invitation
      And I press "Submit"
      When I follow "Accept"
      Then I follow "Accept"
      And I should not see the header
