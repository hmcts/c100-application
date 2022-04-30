require_relative './any_page'
module C100
  module Test
    module PageObjects
      class AnyPage < SitePrism::Page

        def has_google_analytics_enabled?
          wait_until_true(timeout: 100) do
            !google_analytics_enabled
          end
        end

        def has_cookie_preferences_updated_message?
          notification_banner.has_content?(text: "You've set your cookie preferences")
        end

        section :notification_banner, '.govuk-notification-banner' do
          element :title, '.govuk-notification-banner__header.govuk-notification-banner__title'
          element :content, '.govuk-notification-banner__content .govuk-notification-banner__heading'
        end

        section :cookie_banner, '.govuk-cookie-banner' do
          element :accept_button, :button, 'Accept analytics cookies'
          element :reject_button, :button, 'Reject analytics cookies'
          element :link_to_cookie_page, :link, 'View cookies'

          def view_cookies
            link_to_cookie_page.click
          end

          def accept
            accept_button.click
          end

          def reject
            reject_button.click
          end

        end

        section :cookie_confirmation_banner, '.govuk-cookie-banner.confirmation' do
          element :hide_message_button, :button, 'Hide this message'
          element :change_cookie_settings_link, :link, 'change your cookie settings'
          def has_message?(*args)
            message_container.has_message?(*args)
          end

          def hide_message
            hide_message_button.click
          end

          def change_cookie_settings
            change_cookie_settings_link.click
          end

          private

          section :message_container, '.govuk-cookie-banner__message' do
            element :message, '.govuk-cookie-banner__content'
          end
        end

        private

        def google_analytics_enabled
          page.evaluate_script("window['ga-disable-#{Rails.application.config.x.analytics_tracking_id}']")
        end

        def wait_until_true(timeout: Capybara.default_max_wait_time, sleep: 0.1)
          Timeout.timeout(timeout) do
            loop do
              break true if yield
              sleep sleep
            end
          end
        end
      end
    end
  end
end
