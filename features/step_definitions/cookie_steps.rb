And(/^I can choose to reject or accept analytics cookies$/) do
  expect(any_page.cookie_banner).to(have_accept_button.and(have_reject_button))
end

Then(/^I will see a cookie banner above the black page banner$/) do
  expect(any_page).to have_cookie_banner
end

And(/^I can click a link to the cookie page from the cookie banner$/) do
  expect(any_page.cookie_banner).to have_link_to_cookie_page
end

When(/^I click the "View cookies" link in the cookie banner$/) do
  any_page.cookie_banner.view_cookies
end

Then(/^I will be taken to the cookies page$/) do
  expect(cookie_management_page).to be_displayed
end

When(/^I click "Accept analytics cookies" in the cookie banner$/) do
  any_page.cookie_banner.accept
end

When(/^I click "Reject analytics cookies" in the cookie banner$/) do
  any_page.cookie_banner.reject
end

Then(/^I will see a replacement banner telling me that I have accepted analytics cookies$/) do
  expect(any_page.cookie_confirmation_banner).to have_message(text: "You've accepted analytics cookies. You can change your cookie settings at any time.")
end

Then(/^I will see a replacement banner telling me that I have rejected analytics cookies$/) do
  expect(any_page.cookie_confirmation_banner).to have_message(text: "You've rejected analytics cookies. You can change your cookie settings at any time.")
end

And(/^I can choose to 'hide message' in the cookie confirmation banner$/) do
  expect(any_page.cookie_confirmation_banner).to have_hide_message_button
end

When(/^I click "change your cookie settings" from the cookie confirmation banner$/) do
  any_page.cookie_confirmation_banner.change_cookie_settings
end

When(/^I select 'hide message' from the cookie confirmation banner$/) do
  any_page.cookie_confirmation_banner.hide_message
end

Then(/^the cookie confirmation banner will be closed$/) do
  expect(any_page).to have_no_cookie_confirmation_banner
end

And(/^I can click a link to the cookie page from the cookie confirmation banner$/) do
  expect(any_page.cookie_confirmation_banner).to have_change_cookie_settings_link
end
