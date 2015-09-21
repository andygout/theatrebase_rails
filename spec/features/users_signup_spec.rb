require 'rails_helper'

feature 'user sign-up' do
  context 'invalid details' do
    scenario 'should re-render the form with error message', js: true do
      visit new_user_path
      fill_in 'user_name', with: ''
      fill_in 'user_email', with: 'andygout@example'
      fill_in 'user_password', with: 'foo'
      fill_in 'user_password_confirmation', with: 'bar'
      expect { click_button 'Create User' }.to change { User.count }.by 0
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Email is invalid"
      expect(page).to have_content "Password confirmation doesn't match Password"
      expect(page).to have_content "Password is too short (minimum is 6 characters)"
      expect(current_path).to eq users_path
    end
  end
end