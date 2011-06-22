Feature: Viewing someone else's trusted network and my own 

  As a As user who wants to look at other profile
  I want to see if I can see people that are connected with other person 
  In order So I can find new friends
  
  Background:
    Given the user is logged in
    Given a person exists with name: "Maria"
    Given a person exists with name: "Sebastian"
    Given a person exists with name: "Nik"
    Given Looking at person network page with name "Maria"
    
  Scenario: Maria and me are in trusted relationship
    Given "Maria" has trusted relationship with "John"
    Then I follow "Mutual"
    And I should not see "mutual network"
    
  Scenario: Maria and me have mutual friends
    Given "Maria" has trusted relationship with "John"
    Given "Maria" has trusted relationship with "Sebastian"
    Given "Maria" has trusted relationship with "Nik"
    Given "Nik" has trusted relationship with "John"
    Then I follow "Mutual"
    And I should see "Nik"
    And I should not see "Sebastian"
    
  Scenario: Maria has extended friends network
    Given "Maria" has trusted relationship with "John"
    Given "Maria" has trusted relationship with "Sebastian"
    Given "Sebastian" has trusted relationship with "Nik"
    Given "Nik" has trusted relationship with "John"
    Given Looking at person network page with name "Maria"
    #Then I follow "Extended"
    #And I should see "Nik"
    #And I should not see "Sebastian"
    #And I should not see "John"
    
  Scenario: Maria has other friends beside mutual friends with me, but I am also firend with her and se shouldn't see me
    Given a person exists with name: "Kolumbo"
    Given "Maria" has trusted relationship with "John"
    Given "Maria" has trusted relationship with "Sebastian"
    Given "Maria" has trusted relationship with "Nik"
    Given "Maria" has trusted relationship with "Kolumbo"
    Given "Nik" has trusted relationship with "John"
    Then I follow "Others"
    And I should see "Sebastian"
    And I should see "Kolumbo"
    And I should not see "Nik"
    Then I should not see "John" in css class "people-holder"
  
  Scenario: Maria has other friends and I am not in trusted relationship with Maria
    Given a person exists with name: "Kolumbo"
    Given "Maria" has trusted relationship with "Sebastian"
    Given "Maria" has trusted relationship with "Nik"
    Given "Maria" has trusted relationship with "Kolumbo"
    Given "Nik" has trusted relationship with "John"
    Then I follow "Others"
    And I should see "Sebastian"
    And I should see "Kolumbo"
    And I should not see "Nik"
    Then I should not see "John" in css class "people-holder"
    
  
    
    
