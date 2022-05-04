# General and frequently used navigation steps, handling of links and page expectations
#
When(/^I visit "([^"]*)"$/) do |path|
  visit path
end

Then(/^I should be on "([^"]*)"$/) do |page_name|
  expect("#{Capybara.app_host}#{URI.parse(current_url).path}").to eql("#{Capybara.app_host}#{page_name}")
end

Then(/^I should see "([^"]*)"$/) do |text|
  expect(page).to have_text(text)
end

Then(/^I should not see "([^"]*)"$/) do |text|
  expect(page).not_to have_text(text)
end

Then(/^I should see a "([^"]*)" link to "([^"]*)"$/) do |text, href|
  expect(page).to have_link(text, href: href)
end

Then(/^I should see the save draft button$/) do
  expect(page).to have_selector(:button, 'Save and come back later')
end

Then(/^I should not see the save draft button$/) do
  expect(page).not_to have_selector(:button, 'Save and come back later')
end

When(/^I click the "([^"]*)" link$/) do |text|
  click_link(text)
end

When(/^I open the "([^"]*)" summary details$/) do |text|
  find('details > summary > span', text: text).click
end

When(/^I click the "([^"]*)" button$/) do |text|
  find_button("#{text}").click
end

When(/^I have started an application$/) do
  step %[I visit "/"]
  step %[I open the "Developer Tools" summary details]
  find('button', text: 'Bypass postcode').click
  step %[I should be on "/steps/opening/consent_order"]
end

When(/^I am on the home page$/) do
  step %[I visit "/"]
end

When(/^I pause for "([^"]*)" seconds$/) do |seconds|
  sleep seconds.to_i
end

And(/^Page has title "([^"]*)"/) do |text|
  expect(page).to have_title(text)
end

And(/^analytics cookies are NOT allowed to be set$/) do
  expect(page.evaluate_script("window['ga-disable-#{Rails.application.config.x.analytics_tracking_id}']"))
    .to be(true), 'Google analytics is enabled it should not be'
end

Then(/^google analytics cookies are allowed to be set$/) do
  expect(any_page).to have_google_analytics_enabled
end

Given("I stub fact api call") do
  WebMock.enable!
  WebMock.allow_net_connect!
  WebMock::API.stub_request(:get, "https://www.find-court-tribunal.service.gov.uk/v2/proxy/search/postcode/TQ121XX/serviceArea/childcare-arrangements").
  to_return(status: 200, body: "{}", headers: {})

  WebMock::API.stub_request(:get, "https://www.find-court-tribunal.service.gov.uk/health").
    to_return(status: 200, body: "{\"mapit-api\":{\"status\":\"UP\"}}", headers: {})
end