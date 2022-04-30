Feature: Add children to the application
  Background:
    Given I have started an application
    And I have selected orders for the court to decide
    When I visit "steps/children/names"

  @happy_path
  Scenario: Children personal details
    Then I should see "Enter the names of the children"
    And I should see "Enter a new name"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Enter the names of the children - Apply to court about child arrangements - GOV.UK"
    And I should see a "Enter the first name" link to "#steps-children-names-split-form-new-first-name-field-error"
    And I should see a "Enter the last name" link to "#steps-children-names-split-form-new-last-name-field-error"

    # Fix validation errors and continue
    Then I fill in "First name(s)" with "John"
    And I fill in "Last name(s)" with "Doe Junior"

    When I click the "Continue" button
    Then I should see "Provide details for John Doe Junior"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Child personal details - Apply to court about child arrangements - GOV.UK"
    And I should see a "Enter the date of birth" link to "#steps-children-personal-details-form-dob-field-error"
    And I should see a "Select the sex" link to "#steps-children-personal-details-form-gender-field-error"

    # Fix validation errors and continue
    Then I enter the date 08-12-2016
    And I choose "Male"

    When I click the "Continue" button
    Then I should see "Which of the decisions you’re asking the court to resolve relate to John Doe Junior?"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Which orders apply to the child - Apply to court about child arrangements - GOV.UK"
    And I should see a "Select at least a decision" link to "#steps-children-orders-form-orders-field-error"

    # Fix validation errors and continue
    Then I check "Decide how much time they spend with each person"

    When I click the "Continue" button
    Then I should see "Further information"
    And I should see "Are any of the children known to social services?"
    And I should see "Are any of the children the subject of a child protection plan?"

    # Go back and select "home" order to enter the special guardianship question
    When I click the "Back" link
    And I check "Decide who they live with and when"
    When I click the "Continue" button
    Then I should see "Is there a Special Guardianship Order in force in relation to John Doe Junior?"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Special Guardianship Order - Apply to court about child arrangements - GOV.UK"
    And I should see a "Select yes or no" link to "#steps-children-special-guardianship-order-form-special-guardianship-order-field-error"

    # Fix validation errors and continue
    And I choose "No"
    Then I should see "Further information"

    # Provoke validation errors
    When I click the "Continue" button
    Then Page has title "Error: Further information about the children - Apply to court about child arrangements - GOV.UK"
    And I should see a "Select if any of the children are known to social services" link to "#steps-children-additional-details-form-children-known-to-authorities-field-error"
    And I should see a "Select if any of the children are the subject of a child protection plan" link to "#steps-children-additional-details-form-children-protection-plan-field-error"

    # Fix validation errors and continue
    Then I click "No" for the radio button "Are any of the children known to social services?"
    And I click "Yes" for the radio button "Are any of the children the subject of a child protection plan?"

    When I click the "Continue" button
    Then I should see "Do you or any respondents have other children who are not part of this application?"
