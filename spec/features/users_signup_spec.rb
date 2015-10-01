require 'rails_helper'

feature 'User sign-up' do
  context 'valid details' do
    let(:user) { attributes_for :user }
    scenario 'should redirect to user page with success message', js: true do
      visit signup_path
      fill_in 'user_name',                  with: "#{user[:name]}"
      fill_in 'user_email',                 with: "#{user[:email]}"
      fill_in 'user_password',              with: "#{user[:password]}"
      fill_in 'user_password_confirmation', with: "#{user[:password_confirmation]}"
      expect { click_button 'Create User' }.to change { User.count }.by 1
      expect(page).to have_css 'div.alert-success'
      expect(page).not_to have_css 'div.alert-error'
      expect(page).not_to have_css 'li.field_with_errors'
      expect(page).to have_selector :link, 'Profile'
      expect(page).to have_selector :link, 'Log out'
      expect(page).not_to have_selector :link, 'Log in'
      expect(current_path).to eq "/users/1"
    end
  end

  context 'invalid details' do
    let(:invalid_user) { attributes_for :invalid_user }
    scenario 'should re-render the form with error message', js: true do
      visit signup_path
      fill_in 'user_name',                  with: "#{invalid_user[:name]}"
      fill_in 'user_email',                 with: "#{invalid_user[:email]}"
      fill_in 'user_password',              with: "#{invalid_user[:password]}"
      fill_in 'user_password_confirmation', with: "#{invalid_user[:password_confirmation]}"
      expect { click_button 'Create User' }.to change { User.count }.by 0
      expect(page).to have_css 'div.alert-error'
      expect(page).to have_css 'li.field_with_errors'
      expect(page).not_to have_css 'div.alert-success'
      expect(page).to have_selector :link, 'Log in'
      expect(page).not_to have_selector :link, 'Profile'
      expect(page).not_to have_selector :link, 'Log out'
      expect(current_path).to eq users_path
    end
  end
end