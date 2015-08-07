Feature: Logging Out
  In order to remove my session data from my computer
  As a logged-in user
  I want to be able to logout of my account

  Scenario: clicking the logout button brings me back to the homepage
    Given I am logged into my dashboard
    When I click the logout button
    Then I should be on the home page
