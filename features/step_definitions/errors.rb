# Everything that has to do with errors, like the summary, links or focus
#
When(/^I should see "([^"]*)" in the error summary$/) do |text|
  expect(page.find("div.govuk-error-summary > h2")).to have_text(text)
end

When(/^I should see "([^"]*)" error in the form$/) do |text|
  expect(page.find("span.govuk-error-message")).to have_text(text)
end

When(/^"([^"]*)" has focus/) do |text|
  expect(page.evaluate_script("document.activeElement.id")).to eq(text)
end
