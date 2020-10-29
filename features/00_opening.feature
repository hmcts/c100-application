Feature: Opening
  Background:
    When I visit "/"
    Then I should see "You can use this service to apply for a court order about child arrangements."
    And  I click the "Start application" link
    Then I should see "What you’ll need to complete your application"
    And  I click the "Continue" link
    Then I should see "How long it takes to apply"
    And  I click the "Continue" link
    Then I should see "Where do the children live?"
    And  I should not see the save draft button

  @happy_path
  Scenario: Complete the opening
    When I fill in "Postcode" with "MK9 3DX"
    And I click the "Continue" button
    Then I should see "Are you willing to be contacted to share your experience of using this service?"
    And I should not see the save draft button
    And I choose "No"
    Then I should see "What kind of application do you want to make?"
    And I should not see the save draft button
    And I choose "Child arrangements order, prohibited steps order, specific issue order, or to change or end an existing order"
    Then I should see "Are the children involved in any emergency protection, care or supervision proceedings (or have they been)?"
    And I should not see the save draft button
    And I choose "No"
    Then I should see "Attending a Mediation Information and Assessment Meeting (MIAM)"
    And I should see the save draft button

  @unhappy_path
  Scenario: I don't fill out the postcode
    When I click the "Continue" button

    Then I should be on "/steps/opening/postcode"
    And Page has title "Error: Where the children live - Apply to court about child arrangements - GOV.UK"
    And I should see "There is a problem on this page" in the error summary
    And I should see a "Enter a full postcode, with or without a space" link to "#steps-opening-postcode-form-children-postcode-field-error"

    Then I click the "Enter a full postcode, with or without a space" link
    And I should see "Enter a full postcode, with or without a space" error in the form
    And "steps-opening-postcode-form-children-postcode-field-error" has focus

  @unhappy_path
  Scenario: Postcode not eligible
    When I fill in "Postcode" with "ZE2 9TE"
    And I click the "Continue" button

    Then I should see "Sorry, you cannot apply online"
    And I should see a "Download the form (PDF)" link to "https://formfinder.hmctsformfinder.justice.gov.uk/c100-eng.pdf"

  @unhappy_path
  Scenario: Postcode not recognised
    When I fill in "Postcode" with "GU2 9JE"
    And I click the "Continue" button

    Then I should see "Something went wrong"
    And I should see a "Download the form (PDF)" link to "https://formfinder.hmctsformfinder.justice.gov.uk/c100-eng.pdf"
    And I should see a "Go back and try again" link to "/steps/opening/postcode"
