require_relative './any_page'
module C100
  module Test
    module PageObjects
      class CookieManagementPage < AnyPage
        set_url '/about/cookies'

        section :analytics_question, :xpath, XPath.generate { |x| x.descendant(:div)[x.attr(:class).contains_word('govuk-form-group') & x.child(:fieldset)[x.child(:legend)[x.string.n.equals('Do you want to accept analytics cookies?')]]] } do
          def assert_value(expected_value)
            root_element.assert_selector(:radio_button, expected_value, visible: false, checked: true)
          end

          def set(value)
            root_element.find(:radio_button, value, visible: false).click
          end
        end
      end
    end
  end
end
