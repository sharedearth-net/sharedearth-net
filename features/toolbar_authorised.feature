Feature: Checking toolbar and buttons that appear

  As a As common user and un authorised
  I want to see if buttons and toolbar appear properly for each user
  In order check if everything is showing properly
  #Main user is John

  Background:
      Given the invitation system is on
      Given the unauthorised user is logged in
      Given invitation key exsists    
      Then I should see the words "Welcome", "Enter your invitation code to continue" and "sharedearth.net is now in private beta"
      Then I fill in active invitation
      And I press "Submit"
 
  Scenario: I should see page with toolbar and without buttons
    Then I follow "About"
     And I should not see link with text "back"
     And I should not see link with text "disconnect"

  Scenario: I should see page with toolbar and without buttons
    Then I follow "Principles"
     And I should not see link with text "back"
     And I should not see link with text "disconnect"
     And I should not see link with text "Connect"

  Scenario: I should see page with toolbar and without buttons
    Then I follow "Transparency"
     And I should not see link with text "back"
     And I should not see link with text "disconnect"
     And I should not see link with text "Accept"

  Scenario: I should see page with toolbar and without buttons
    Then I follow "Contribute"
     And I should not see link with text "back"
     And I should not see link with text "disconnect"
@javascript
  Scenario: I should see page with toolbar and without buttons
    Then I follow "Terms"
     And I should not see link with text "back"
     And I should not see link with text "disconnect"
     And I should see link with text "Accept"

  Scenario: I should see page with toolbar and without buttons
    Then I follow "Accept"
    Then I follow "Principles"
     And I should not see link with text "back"
     And I should not see link with text "disconnect"
     And I should not see link with text "Connect"

  Scenario: I should see page with toolbar and without buttons
    Then I follow "Accept"
    Then I follow "Transparency"
     And I should not see link with text "back"
     And I should not see link with text "disconnect"
     And I should see link with text "Accept"

  Scenario: I should see page with toolbar and without buttons
    Then I follow "Accept"
    Then I follow "Terms"
     And I should not see link with text "back"
     And I should not see link with text "disconnect"
     And I should not see link with text "Accept"

  Scenario: I should see page with toolbar and without buttons
    Then I follow "Accept"
    Then I follow "Accept"
    Then I follow "Principles"
     And I should not see link with text "back"
     And I should not see link with text "disconnect"
     And I should see link with text "No thanks"

  Scenario: I should see page with toolbar and without buttons
    Then I follow "Accept"
    Then I follow "Accept"
    Then I follow "Transparency"
     And I should not see link with text "back"
     And I should not see link with text "disconnect"
     And I should not see link with text "Accept"
@javascript
  Scenario: I should see page with toolbar and without buttons
    Then I follow "Accept"
    Then I follow "Accept"
    Then I follow "Terms"
     And I should not see link with text "back"
     And I should not see link with text "disconnect"
     And I should not see link with text "Accept"






