Feature: Cookie banner
  Background:
    Given I am on the home page
  Scenario: basic contents
    Then I will see a cookie banner above the black page banner
    And I can choose to reject or accept analytics cookies
    And I can click a link to the cookie page from the cookie banner
  Scenario: View cookies link
    When I click the "View cookies" link in the cookie banner
    Then I will be taken to the cookies page
  Scenario: Accepting analytics cookies
    When I click "Accept analytics cookies" in the cookie banner
    Then I will see a replacement banner telling me that I have accepted analytics cookies
    And I can click a link to the cookie page from the cookie confirmation banner
    And I can choose to 'hide message' in the cookie confirmation banner
  Scenario: Reject analytics cookies
    When I click "Reject analytics cookies" in the cookie banner
    Then I will see a replacement banner telling me that I have rejected analytics cookies
    And I can click a link to the cookie page from the cookie confirmation banner
    And I can choose to 'hide message' in the cookie confirmation banner
  Scenario: Changing cookie settings once accepted using banner
    When I click "Accept analytics cookies" in the cookie banner
    When I click "change your cookie settings" from the cookie confirmation banner
    Then I will be taken to the cookies page
    And google analytics cookies are allowed to be set
  Scenario: Changing cookie settings once rejected using banner
    When I click "Reject analytics cookies" in the cookie banner
    When I click "change your cookie settings" from the cookie confirmation banner
    Then I will be taken to the cookies page
    And analytics cookies are NOT allowed to be set
  Scenario: Closing the confirmation banner after accepting analytics cookies
    When I click "Accept analytics cookies" in the cookie banner
    When I select 'hide message' from the cookie confirmation banner
    Then the cookie confirmation banner will be closed
    And google analytics cookies are allowed to be set
  Scenario: Closing the confirmation banner after rejecting analytics cookies
    When I click "Reject analytics cookies" in the cookie banner
    When I select 'hide message' from the cookie confirmation banner
    Then the cookie confirmation banner will be closed
    And analytics cookies are NOT allowed to be set

