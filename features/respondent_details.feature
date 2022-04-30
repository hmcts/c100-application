Feature: Add a respondent to the application
  Background:
    # We need at least 1 child as a precondition for this journey
    Given I have started an application
    And I have entered a child with first name "John" and last name "Doe Junior"
    Then I visit "steps/respondent/names"

  @happy_path
  Scenario: Respondent personal details
    Then I should see "Enter the respondent’s name"
    And I should see "Enter a new name"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Respondent names - Apply to court about child arrangements - GOV.UK"
    And I should see a "Enter the first name" link to "#steps-respondent-names-split-form-new-first-name-field-error"
    And I should see a "Enter the last name" link to "#steps-respondent-names-split-form-new-last-name-field-error"

    # Fix validation errors and continue
    Then I fill in "First name(s)" with "Olivia"
    And I fill in "Last name(s)" with "Doe Senior"
    When I click the "Continue" button
    Then I should see "Provide details for Olivia Doe Senior"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Respondent personal details - Apply to court about child arrangements - GOV.UK"
    And I should see a "Select if they’ve changed their name" link to "#steps-respondent-personal-details-form-has-previous-name-field-error"
    And I should see a "Select the sex" link to "#steps-respondent-personal-details-form-gender-field-error"
    And I should see a "Enter the date of birth" link to "#steps-respondent-personal-details-form-dob-field-error"

    # Fix validation errors and continue
    Then I click "Don't know" for the radio button "Have they changed their name?"
    And I choose "Female"
    And I enter the date 25-05-2012
    And I fill in "Place of birth" with "London"
    When I click the "Continue" button
    Then I should see "What is Olivia Doe Senior's relationship to John Doe Junior?"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Respondent relationship - Apply to court about child arrangements - GOV.UK"
    And I should see a "Select the relationship" link to "#steps-shared-relationship-form-relation-field-error"

    # Fix validation errors and continue
    Then I choose "Mother"
    When I click the "Continue" button
    Then I should see "Address of Olivia Doe Senior"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Address lookup - Apply to court about child arrangements - GOV.UK"
    And I should see a "Enter the postcode" link to "#steps-address-lookup-form-postcode-field-error"

    # Fix validation errors and continue (do not use lookup API)
    When I click the "I don’t know their postcode or they live outside the UK" link
    And I should see "Address details of Olivia Doe Senior"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Respondent address details - Apply to court about child arrangements - GOV.UK"
    And I should see a "Enter the first line of the address or select if you don’t know where they live" link to "#steps-respondent-address-details-form-address-line-1-field-error"
    And I should see a "Enter the town or city or select if you don’t know where they live" link to "#steps-respondent-address-details-form-town-field-error"
    And I should see a "Select yes if they’ve lived at the address for more than 5 years" link to "#steps-respondent-address-details-form-residence-requirement-met-field-error"

    # Fix validation errors and continue
    When I fill in "Building and street" with "Test street"
    And I fill in "Town or city" with "London"
    And I click "Don't know" for the radio button "Have they lived at this address for more than 5 years?"
    When I click the "Continue" button

    # Provoke validation errors on contact details page
    When I click the "Continue" button
    Then Page has title "Error: Respondent contact details - Apply to court about child arrangements - GOV.UK"
    And I should see a "Enter an email address in the correct format, like name@example.com" link to "#steps-respondent-contact-details-form-email-field-error"
    And I should see a "Enter an answer" link to "#steps-respondent-contact-details-form-home-phone-field-error"
    And I should see a "Enter an answer" link to "#steps-respondent-contact-details-form-mobile-phone-field-error"

    # Fix validation errors and continue    
    When I fill in "Email address" with "test@example.com"
    And I fill in "Home phone" with "07777777777"
    And I fill in "Mobile phone" with "07777777777"

    When I click the "Continue" button
    Then I should see "Is there anyone else who should know about your application?"
    Then I choose "No"
    Then I should see "Who does John Doe Junior currently live with?"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Child residence - Apply to court about child arrangements - GOV.UK"
    And I should see a "You must select at least one person" link to "#steps-children-residence-form-person-ids-field-error"

    # Fix validation errors and continue
    Then I check "Olivia Doe Senior"
    When I click the "Continue" button

    # Finalise here as we exit the `people` journeys
    Then I should see "Have any of the children in this application been involved in other family court proceedings?"
