Feature: High level form markup smoke tests
  Background:
    Given I have started an application

  Scenario Outline: Markup in a sample of forms should be correct
    When I visit "<step_path>"

    Then The form markup should match "<fixture_file>"
    Then The form markup with errors should match "<errors_fixture_file>"

    Examples:
      | step_path                            | fixture_file            | errors_fixture_file                 |
      | steps/opening/child_protection_cases | child_protection_cases  | child_protection_cases_with_errors  |
      | steps/miam/acknowledgement           | miam_acknowledgement    | miam_acknowledgement_with_errors    |
      | steps/miam/certification_date        | miam_certification_date | miam_certification_date_with_errors |
      | steps/petition/orders                | nature_of_application   | nature_of_application_with_errors   |
      | steps/international/jurisdiction     | order_jurisdiction      | order_jurisdiction_with_errors      |
