Feature: Welcome page

  As a As user who loads web page for first time
  I want see if welcome page is showing
  In order So I can connect to my profile
  
  Scenario: Sign in thru Facebook
    Given the user is logged in
    Then I should see "disconnect"
    Then I follow "John"
    Then I should see "edit"
