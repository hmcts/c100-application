Feature: MIAM voucher acknowledgement

  Background:
    Given I have started an application
    When I visit "steps/miam/acknowledgement"

  Scenario: MIAM voucher
    Then I should see "Have you previously been to mediation through the mediation voucher scheme?"

   Scenario: You're exempt link
     Then I should see a "you’re exempt" link to "/about/miam_exemptions"

    Scenario: Mediation link
      Then I should see a "mediation" link to "https://helpwithchildarrangements.service.justice.gov.uk/professional-mediation"

     Scenario: Check if you’re eligible for legal aid during mediation link
       Then I should see a "Check if you’re eligible for legal aid during mediation" link to "https://www.gov.uk/check-legal-aid"

      Scenario: Find a mediator to book a MIAM link
        Then I should see a "Find a mediator to book a MIAM" link to "https://www.familymediationcouncil.org.uk/find-local-mediator/"

      Scenario: List of valid reasons for not attending a MIAM link
        Then I should see a "List of valid reasons for not attending a MIAM" link to "/about/miam_exemptions"

  Scenario: Checkbox complete - Yes
    When I check "I understand that I have to attend a MIAM or provide a valid reason for not attending."
    And I choose "Yes"
    And I click the "Continue" button
    Then I should be on "/steps/miam/attended"

  Scenario: Checkbox complete - No
    When I check "I understand that I have to attend a MIAM or provide a valid reason for not attending."
    And I choose "No"
    And I click the "Continue" button
    Then I should be on "/steps/miam/attended"

  Scenario: Checkbox incomplete
    When I click the "Continue" button
    Then I should see "Confirm you understand MIAM attendance requirements"




