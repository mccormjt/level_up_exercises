Feature: Signing Up
  In order to remeber users preferences and previous session data
  As a user
  I want to be able to sign up for an account

  Background: Starting the signup process
    Given I am on the home page
    When I click the signup button

  Scenario: Starts the signup process
    Then I should see the signup form

  Scenario: Entering a valid fields
    And I submit the signup form with valid fields
    Then I should see my dashboard

  Scenario: Not entering a name
    And I submit the signup form without a name
    Then I should see a "name" danger alert

  Scenario: Entering an invalid phone number
    And I submit the signup form with an invalid phone number
    Then I should see a "phone number" danger alert

  Scenario: Entering too short of a password
    And I submit the signup form with too short of a password
    Then I should see a "password is too short" danger alert

  Scenario: Entering mismatching passwords
    And I submit the signup form with mismatching passwords
    Then I should see a "doesn't match password" danger alert
