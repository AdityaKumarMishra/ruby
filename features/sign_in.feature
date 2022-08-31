@javascript
Feature: User should be able to create new task
  Background:
    Given there is a registered user
  Scenario: User signed in successfully
    When the user signs in
    Then the user should see successful login message

  Scenario: User signed in unsuccessfully
    When the user types incorrect username or password
    Then the user should see invalid credentials messages