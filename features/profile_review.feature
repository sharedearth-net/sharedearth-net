Feature:
   In order to have my profile up to date
   As a new user
   I want to know when I need to update my profile

   Scenario: User signs in for the first time
      Given a new person exists
      And that person logs in
      When that person accepts all terms and conditions
      Then I should be at that person profile page

   Scenario: User signs in for the fist time and updates it's profile
      Given a new person exists
      And that person logs in
      When that person accepts all terms and conditions
      And I fill in "person_name" with "Juan"
      And I press "Save"
      Then I should be on the dashboard page

   Scenario: User signs in for the first time and doesn't update it's profile
      Given a new person exist
      And that person logs in
      When that person accepts all terms and conditions
      And I follow "cancel"
      Then I should be on the dashboard page

   Scenario: User signs in after reviewing its profile
      Given a person exist
      And that person logs in
      And that person has reviewed its profile
      When I go to the edit page of that person
      And I press "Save"
      Then I should be on the show page of that person

   Scenario: User signs in after reviewing its profile, but does not change profile
      Given a person exist
      And that person logs in
      And that person has reviewed its profile
      When I go to the edit page of that person
      And I follow "cancel"
      Then I should be on the show page of that person

   Scenario: New user edits profile after reviewing it and updates it
      Given a new person exist
      And that person logs in
      When that person accepts all terms and conditions
      And I fill in "person_name" with "Juan"
      And I press "Save"
      And I go to the edit page of that person
      And I fill in "person_name" with "Pedro"
      And I press "Save"
      Then I should be on the show page of that person
      
   Scenario: New user edits profile after reviewing it and does not updates it
      Given a new person exist
      And that person logs in
      When that person accepts all terms and conditions
      And I follow "cancel"
      And I go to the edit page of that person
      And I follow "cancel"
      Then I should be on the show page of that person
