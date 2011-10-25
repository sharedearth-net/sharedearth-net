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
@javascript
  Scenario: I should see page with toolbar and without buttons
    Then I follow "About"
    Then I should see the words "back", "About", "Principles", "Transparency", "Contribute", "Contact", "Terms"
     And I should not see "Connect" in a link
     And I should not see "No thanks" in a link
     And I should not see "Reject" in a link
@javascript
  Scenario: I should see page with toolbar and without buttons
    Then I follow "Principles"
    Then I should see the words "back", "About", "Principles", "Transparency", "Contribute", "Contact", "Terms"
     And I should not see "Connect" in a link
     And I should not see "No thanks" in a link
     And I should not see "Reject" in a link

  Scenario: I should see page with toolbar and without buttons
    Then I follow "Transparency"
    Then I should see the words "back", "About", "Principles", "Transparency", "Contribute", "Contact", "Terms"
     And I should not see "Connect" in a link
     And I should not see "No thanks" in a link
     And I should not see "Reject" in a link

  Scenario: I should see page with toolbar and without buttons
    Then I follow "Contribute"
    Then I should see the words "back", "About", "Principles", "Transparency", "Contribute", "Contact", "Terms"
     And I should not see "Connect" in a link
     And I should not see "No thanks" in a link
     And I should not see "Reject" in a link

  Scenario: I should see page with toolbar and without buttons
    Then I follow "Terms"
    Then I should see the words "back", "About", "Principles", "Transparency", "Contribute", "Contact", "Terms"
     And I should not see "Connect" in a link
     And I should not see "No thanks" in a link
     And I should not see "Reject" in a link

