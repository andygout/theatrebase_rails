require 'rails_helper'

feature 'User edit' do
  context 'logged in as admin; updating own profile' do
    let(:admin_user) { create_logged_in_admin_user }
    let(:edit_user) { attributes_for :edit_user }
    let(:invalid_user) { attributes_for :invalid_user }

    scenario 'valid details redirect to user profile with success message', js: true do
      visit edit_user_path(admin_user)
      fill_in 'user_name',                  with: edit_user[:name]
      fill_in 'user_email',                 with: edit_user[:email]
      fill_in 'user_password',              with: edit_user[:password]
      fill_in 'user_password_confirmation', with: edit_user[:password_confirmation]
      click_button 'Update User'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(current_path).to eq user_path(admin_user)
    end

    scenario 'invalid details re-render form with error message', js: true do
      visit edit_user_path(admin_user)
      fill_in 'user_name',                  with: invalid_user[:name]
      fill_in 'user_email',                 with: invalid_user[:email]
      fill_in 'user_password',              with: invalid_user[:password]
      fill_in 'user_password_confirmation', with: invalid_user[:password_confirmation]
      click_button 'Update User'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq user_path(admin_user)
    end
  end

  context 'logged in as admin; attempt to edit another user profile' do
    let(:user) { create :user }

    scenario 'redirect to home page', js: true do
      create_logged_in_admin_user
      visit edit_user_path(user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'logged in as non-admin; updating own profile' do
    let(:user) { create_logged_in_user }
    let(:edit_user) { attributes_for :edit_user }
    let(:invalid_user) { attributes_for :invalid_user }

    scenario 'update with valid details; redirect to user profile with success message', js: true do
      visit edit_user_path(user)
      fill_in 'user_name',                  with: edit_user[:name]
      fill_in 'user_email',                 with: edit_user[:email]
      fill_in 'user_password',              with: edit_user[:password]
      fill_in 'user_password_confirmation', with: edit_user[:password_confirmation]
      click_button 'Update User'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(current_path).to eq user_path(user)
    end

    scenario 'update with invalid details; re-render form with error message', js: true do
      visit edit_user_path(user)
      fill_in 'user_name',                  with: invalid_user[:name]
      fill_in 'user_email',                 with: invalid_user[:email]
      fill_in 'user_password',              with: invalid_user[:password]
      fill_in 'user_password_confirmation', with: invalid_user[:password_confirmation]
      click_button 'Update User'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq user_path(user)
    end
  end

  context 'logged in as non-admin; attempt to edit another user profile' do
    let(:second_user) { create :second_user }

    scenario 'redirect to home page', js: true do
      create_logged_in_user
      visit edit_user_path(second_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'not logged in' do
    let(:user) { create :user }

    scenario 'redirect to login page', js: true do
      visit edit_user_path(user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq login_path
    end
  end

  context 'friendly forwarding: logging in redirects to intended user edit page (if permitted)' do
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }

    scenario 'log in as admin; redirect to own user edit page', js: true do
      visit edit_user_path(admin_user)
      login admin_user
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(current_path).to eq edit_user_path(admin_user)
    end

    scenario 'log in as admin; redirect to home page (another user edit page not permitted)', js: true do
      visit edit_user_path(user)
      login admin_user
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq root_path
    end

    scenario 'log in as non-admin; redirect to own user edit page', js: true do
      visit edit_user_path(user)
      login user
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(current_path).to eq edit_user_path(user)
    end

    scenario 'log in as non-admin; redirect to home page (another user edit page not permitted)', js: true do
      visit edit_user_path(admin_user)
      login user
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq root_path
    end
  end
end
