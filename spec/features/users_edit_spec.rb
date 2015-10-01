require 'rails_helper'

feature 'User edit' do
  context 'valid details' do
    let(:user) { create_logged_in_user }
    let(:edit_user) { attributes_for :edit_user }
    scenario 'should redirect to user page with success message', js: true do
      visit edit_user_path(user)
      fill_in 'user_name',                  with: "#{edit_user[:name]}"
      fill_in 'user_email',                 with: "#{edit_user[:email]}"
      fill_in 'user_password',              with: "#{edit_user[:password]}"
      fill_in 'user_password_confirmation', with: "#{edit_user[:password_confirmation]}"
      click_button 'Update User'
      expect(page).to have_css 'div.alert-success'
      expect(page).not_to have_css 'div.alert-error'
      expect(page).not_to have_css 'li.field_with_errors'
      expect(current_path).to eq user_path(user)
    end
  end

  context 'invalid details' do
    let(:user) { create_logged_in_user }
    let(:invalid_user) { attributes_for :invalid_user }
    scenario 'should re-render form with error message', js: true do
      visit edit_user_path(user)
      fill_in 'user_name',                  with: "#{invalid_user[:name]}"
      fill_in 'user_email',                 with: "#{invalid_user[:email]}"
      fill_in 'user_password',              with: "#{invalid_user[:password]}"
      fill_in 'user_password_confirmation', with: "#{invalid_user[:password_confirmation]}"
      click_button 'Update User'
      expect(page).to have_css 'div.alert-error'
      expect(page).to have_css 'li.field_with_errors'
      expect(page).not_to have_css 'div.alert-success'
      expect(current_path).to eq user_path(user)
    end
  end

  context 'not logged in' do
    let(:user) { create :user }
    scenario 'should redirect to login page', js: true do
      visit edit_user_path(user)
      expect(page).to have_css 'div.alert-error'
      expect(current_path).to eq login_path
    end
  end
end