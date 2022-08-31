Given(/^there are a number of registered users$/) do
  @other_user1 = FactoryGirl.create(:user)
  @other_user2 = FactoryGirl.create(:user)
end

Given(/^there is a registered user$/) do
  @user = FactoryGirl.create(:user, role: 'admin')
end

When(/^the user signs in$/) do
  visit '/login'
  fill_in 'user_email', with: @user.email
  fill_in 'user_password', with: @user.password
  click_on 'Sign in'
end