Given("I am on safety concern page") do
  choose('Consent order', visible: :all)
  click_button "Continue"
  expect(page).to have_text "You do not have to attend a MIAM"
  click_link("Continue")
  expect(page).to have_text "Are the children involved in any emergency protection, care or supervision proceedings (or have they been)?"
  choose('No', visible: :all)
  click_button "Continue"
  expect(page).to have_text "Safety concerns"
  click_link("Continue")
  expect(page).to have_text "Keeping your contact details private"
end

Then("I create an account") do
  click_button "Save and come back later"
  expect(page).to have_text "Save your application"
  fill_in "Your email address", with: "email#{rand(100)}@test.com"
  fill_in "Create a password", with: 'password123456'
  click_button "Create account"
end
