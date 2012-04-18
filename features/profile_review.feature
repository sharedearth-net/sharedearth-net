Feature:
   In order to have my profile up to date
   As a new user
   I want to know when I need to update my profile

   #Background:
   # Given the user is logged in

@javascript
  Scenario: User signs in for the first time
      Given the authorised user is logged in
      Given the user accepts all terms
      Then I should see the words "Edit Profile", "Your name", "Location", "About me", "Enable smart email notifications"

@javascript
   Scenario: User signs in for the fist time and updates it's profile
      Given the authorised user is logged in
      Given the user accepts all terms
      Then I should see the words "Edit Profile"
      And I fill in "person_name" with "Juan"
      And I press "Save"
      Then I should be on the dashboard page

   Scenario: User signs in for the first time and doesn't update it's profile
      Given the authorised user is logged in
      Given the user accepts all terms
      Then I should see the words "Edit Profile"
      And I follow "cancel"
      Then I should be on the dashboard page

   Scenario: User signs in after reviewing its profile
      Given the user is logged in
      Then I should not see "Edit Profile"

   Scenario: User signs in after reviewing its profile
      Given the user is logged in
      Then I should not see "Edit Profile"
      Then I follow "John"
      Then I follow "edit profile"
      Then I should see the words "Edit Profile"
      And I fill in "person_name" with "Juan"
      And I press "Save"
      Then I should be on the dashboard page

