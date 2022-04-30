Feature: Create account for applicant
  Background:
    Given I have started an application
    And I am on safety concern page

  Scenario: Applicant create account
    Then I create an account
    And I should see "Your application has been saved"
