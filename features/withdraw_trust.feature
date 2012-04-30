Feature: Withdrawing trust from a trusted person
	 In order to manage my trusted network
	 As a signed in user
	 I want to be able to withdraw trust

Background:
	 Given the user is logged in
	 Given a person exists with name: "Maria"

Scenario: John withdraws trust from Maria
	 And me and "Maria" have a trust relationship
	 Given I am on "Maria"'s profile page
	 And I follow "withdraw trust"
	 And I should see "trust"
	 And I follow "home"
	 And I should see "0 people in your trusted network"
