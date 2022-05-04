Feature: Add an applicant to the application
  Background:
    # We need at least 1 child as a precondition for this journey
    Given I have started an application
    And I have entered a child with first name "John" and last name "Doe Junior"
    Then I visit "steps/applicant/names"

  @happy_path
  Scenario: Applicant personal details
    Then I should see "Enter your name"
    And I should see "Enter a new name"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Applicant names - Apply to court about child arrangements - GOV.UK"
    And I should see a "Enter the first name" link to "#steps-applicant-names-split-form-new-first-name-field-error"
    And I should see a "Enter the last name" link to "#steps-applicant-names-split-form-new-last-name-field-error"

    # Fix validation errors and continue
    Then I fill in "First name(s)" with "John"
    And I fill in "Last name(s)" with "Doe Senior"
    When I click the "Continue" button
    Then I should see "Provide details for John Doe Senior"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Applicant personal details - Apply to court about child arrangements - GOV.UK"
    And I should see a "Select if you’ve changed your name" link to "#steps-applicant-personal-details-form-has-previous-name-field-error"
    And I should see a "Select the sex" link to "#steps-applicant-personal-details-form-gender-field-error"
    And I should see a "Enter the date of birth" link to "#steps-applicant-personal-details-form-dob-field-error"
    And I should see a "Enter your place of birth" link to "#steps-applicant-personal-details-form-birthplace-field-error"

    # Fix validation errors and continue
    Then I click "No" for the radio button "Have you changed your name?"
    And I choose "Male"
    And I fill in "Your place of birth" with "Manchester"

    # For an under 18 applicant
    Then I enter the date 25-05-2020
    When I click the "Continue" button
    Then I should see "As the applicant is under 18"

    # Get back
    And I click the "Back" link

    # For an over 18 applicant
    Then I enter the date 25-05-1998
    When I click the "Continue" button
    Then I should see "What is John Doe Senior's relationship to John Doe Junior?"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Applicant relationship - Apply to court about child arrangements - GOV.UK"
    And I should see a "Select the relationship" link to "#steps-shared-relationship-form-relation-field-error"

    # Fix validation errors and continue
    Then I choose "Father"
    When I click the "Continue" button
    Then I should see "Address of John Doe Senior"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Address lookup - Apply to court about child arrangements - GOV.UK"
    And I should see a "Enter the postcode" link to "#steps-address-lookup-form-postcode-field-error"

    # Fix validation errors and continue (do not use lookup API)
    When I click the "I live outside the UK" link
    And I should see "Address details of John Doe Senior"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Applicant address details - Apply to court about child arrangements - GOV.UK"
    And I should see a "Enter the first line of the address" link to "#steps-applicant-address-details-form-address-line-1-field-error"
    And I should see a "Enter the town or city" link to "#steps-applicant-address-details-form-town-field-error"
    And I should see a "Enter the country" link to "#steps-applicant-address-details-form-country-field-error"
    And I should see a "Select yes if you’ve lived at the address for more than 5 years" link to "#steps-applicant-address-details-form-residence-requirement-met-field-error"

    # Fix validation errors and continue
    When I fill in "Building and street" with "Test street"
    And I fill in "Town or city" with "London"
    And I fill in "Country" with "United Kingdom"
    And I click "Yes" for the radio button "Have you lived at your current address for more than 5 years?"
    When I click the "Continue" button
    Then I should see "Contact details of John Doe Senior"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Applicant contact details - Apply to court about child arrangements - GOV.UK"
    And I should see a "Select an option" link to "#steps-applicant-contact-details-form-email-provided-field-error"
    And I should see a "Enter a mobile number or tell us why the court cannot phone you" link to "#steps-applicant-contact-details-form-mobile-phone-field-error"
    And I should see a "Select yes if the court can leave you a voicemail" link to "#steps-applicant-contact-details-form-voicemail-consent-field-error"

   # Fix validation errors and provoke email validation error
    When I choose "I can provide an email address"
    And I fill in "Your mobile phone" with "0123456789"
    And I choose "Yes, the court can leave me a voicemail"
    When I click the "Continue" button

    # Check email error
    Then Page has title "Error: Applicant contact details - Apply to court about child arrangements - GOV.UK"
    And I should see a "Enter an email address in the correct format, like name@example.com" link to "#steps-applicant-contact-details-form-email-field-error"

    # Fix email validation error and continue
    And I fill in "Your email address" with "test@example.com"
    When I click the "Continue" button


    Then I should see "Will you be legally represented by a solicitor in these proceedings?"
    And I choose "No"

    # Finalise here as we start the respondent journey
    Then I should see "Enter the respondent’s name"
