Feature: Welcome page

  As a As user who loads web page for first time
  I want see if welcome page is showing
  In order So I can connect to my profile
#    @omniauth_test
#  Scenario: Load welcome page
#  Given I am on the home page
#  And I am signed in with provider "Facebook"
#  Then I should see "Connect"
  
  @omniauth_test
  Scenario: Sign in thru Facebook
    Given I am on the home page
    Then I should see "Connect"
    And I follow "Connect"
    Then I should see "News"
