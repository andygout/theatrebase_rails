require 'rails_helper'

feature 'User sign-up' do
  context 'valid details' do
    let(:user) { attributes_for :user }
    scenario 'redirect to user page with success message', js: true do
      visit signup_path
      fill_in 'user_name',                  with: "#{user[:name]}"
      fill_in 'user_email',                 with: "#{user[:email]}"
      fill_in 'user_password',              with: "#{user[:password]}"
      fill_in 'user_password_confirmation', with: "#{user[:password_confirmation]}"
      expect { click_button 'Create User' }.to change { User.count }.by 1
      expect(page).to have_css 'p.alert-success'
      expect(page).not_to have_css 'p.alert-error'
      expect(page).not_to have_css 'li.field_with_errors'
      expect(page).to have_link('Profile', href: user_path(User.last.id))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).not_to have_link('Log in', href: login_path)
      expect(current_path).to eq "/users/1"
    end
  end

  context 'invalid details' do
    let(:invalid_user) { attributes_for :invalid_user }
    scenario 're-render form with error message', js: true do
      visit signup_path
      fill_in 'user_name',                  with: "#{invalid_user[:name]}"
      fill_in 'user_email',                 with: "#{invalid_user[:email]}"
      fill_in 'user_password',              with: "#{invalid_user[:password]}"
      fill_in 'user_password_confirmation', with: "#{invalid_user[:password_confirmation]}"
      expect { click_button 'Create User' }.to change { User.count }.by 0
      expect(page).to have_css 'p.alert-error'
      expect(page).to have_css 'li.field_with_errors'
      expect(page).not_to have_css 'p.alert-success'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq users_path
    end
  end
end