Feature: FB friends listing
   As a signed in user
   I want to be able to see if my FB friends are on sharedearth
   In order to create trust relationships with them

   Background:
      Given the user is logged in
      And a person exist with name: "Martin"
      And a person exist with name: "Marceline"
      And a person exist with name: "Marco"

   Scenario: Listing my FB friends on the '/findtheothers' page
      Given me and "Marceline" are friends on FB
      When I go to findtheothers page
      Then I should not see "Martin"
      And I should see "Marceline"

   Scenario: Listing my FB friends in alpha order
      Given "Marceline" and "Martin" are my friends on FB
      When I go to findtheothers page
      Then I should see "Marceline" and then "Martin"

   Scenario: Displaying the right links on the search pane
      Given me and "Marceline" are friends on FB
      When I go to findtheothers page
      Then I should see "Find the Others"
      And I should see "Facebook Friends"
      And I should see "Search"
      And I should not see "All Results"

   Scenario: Requesting trust through 'acknowledge trusted relationship' link
      Given me and "Marceline" are friends on FB
      When I go to findtheothers page
      And I follow "trust"
      And I go to the dashboard page
      Then I should see "You are establishing a trusted relationship with Marceline"

   Scenario: Canceling a trust request previously made
      Given me and "Marceline" are friends on FB
      And I have made a trust request to "Marceline"
      When I go to findtheothers page
      Then I should see "cancel trust request"

   Scenario: Canceling trust from a trusted person
      Given me and "Marceline" are friends on FB
      And me and "Marceline" have a trust relationship
      When I go to findtheothers page
      Then I should see "withdraw trust"

   Scenario: Searching for FB friends
      Given "Marceline" and "Martin" are my friends on FB
      When I go to findtheothers page
      And I fill in "search_terms" with "Marc"
      And I press "fb-search" 
      Then I should not see "Martin"
      And I should not see "Marco"
      And I should see "Marceline"
