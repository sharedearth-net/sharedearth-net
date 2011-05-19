Feature: Welcome page

  As a As user who loads web page for first time
  I want see if welcome page is showing
  In order So I can connect to my profile
  
  Scenario: Load welcome page
  Given I am on the home page
  #And I am not logged in
  Then I should see "Connect"
