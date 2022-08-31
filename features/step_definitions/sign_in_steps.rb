Then(/^the user should see successful login message$/) do
  expect(page).to have_content 'Signed in successfully.'
end

When(/^the user types incorrect username or password$/) do
  visit '/login'
  fill_in 'user_email', with: ''
  fill_in 'user_password', with: ''
  click_on 'Sign in'
end

Then(/^the user should see invalid credentials messages$/) do
  expect(page).to have_content 'Invalid email or password.'
end