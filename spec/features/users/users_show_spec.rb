require 'rails_helper'

feature 'User profile' do
  context 'logged in as super-admin' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:second_super_admin_user) { create :second_super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }

    scenario 'viewing own super-admin user profile: show own super-admin user profile page', js: true do
      visit user_path(super_admin_user)
      expect(page).to have_content super_admin_user.name
      expect(page).to have_content super_admin_user.email
      expect(page).to have_button('Edit User')
      expect(page).not_to have_button('Edit Admin Status')
      expect(page).not_to have_button('Delete User')
      expect(current_path).to eq user_path(super_admin_user)
    end

    scenario 'viewing another super-admin user profile: show super-admin user profile page', js: true do
      visit user_path(second_super_admin_user)
      expect(page).to have_content second_super_admin_user.name
      expect(page).to have_content second_super_admin_user.email
      expect(page).not_to have_button('Edit User')
      expect(page).not_to have_button('Edit Admin Status')
      expect(page).not_to have_button('Delete User')
      expect(current_path).to eq user_path(second_super_admin_user)
    end

    scenario 'viewing admin user profile: show admin user profile page', js: true do
      visit user_path(admin_user)
      expect(page).to have_content admin_user.name
      expect(page).to have_content admin_user.email
      expect(page).not_to have_button('Edit User')
      expect(page).to have_button('Edit Admin Status')
      expect(page).to have_button('Delete User')
      expect(current_path).to eq user_path(admin_user)
    end

    scenario 'viewing non-admin user profile: show non-admin user profile page', js: true do
      visit user_path(user)
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_button('Delete User')
      expect(page).to have_button('Edit Admin Status')
      expect(page).not_to have_button('Edit User')
      expect(current_path).to eq user_path(user)
    end
  end

  context 'logged in as admin' do
    let(:super_admin_user) { create :super_admin_user }
    let!(:admin_user) { create_logged_in_admin_user }
    let(:second_admin_user) { create :second_admin_user }
    let(:user) { create :user }

    scenario 'viewing super-admin user profile: show super-admin user profile page', js: true do
      visit user_path(super_admin_user)
      expect(page).to have_content super_admin_user.name
      expect(page).to have_content super_admin_user.email
      expect(page).not_to have_button('Edit User')
      expect(page).not_to have_button('Edit Admin Status')
      expect(page).not_to have_button('Delete User')
      expect(current_path).to eq user_path(super_admin_user)
    end

    scenario 'viewing own user admin user profile: show own admin user profile page', js: true do
      visit user_path(admin_user)
      expect(page).to have_content admin_user.name
      expect(page).to have_content admin_user.email
      expect(page).to have_button('Edit User')
      expect(page).not_to have_button('Edit Admin Status')
      expect(page).to have_button('Delete User')
      expect(current_path).to eq user_path(admin_user)
    end

    scenario 'viewing another admin user profile: show admin user profile page', js: true do
      visit user_path(second_admin_user)
      expect(page).to have_content second_admin_user.name
      expect(page).to have_content second_admin_user.email
      expect(page).not_to have_button('Edit User')
      expect(page).not_to have_button('Edit Admin Status')
      expect(page).not_to have_button('Delete User')
      expect(current_path).to eq user_path(second_admin_user)
    end

    scenario 'viewing non-admin user profile: show non-admin user profile page', js: true do
      visit user_path(user)
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_button('Delete User')
      expect(page).not_to have_button('Edit Admin Status')
      expect(page).not_to have_button('Edit User')
      expect(current_path).to eq user_path(user)
    end
  end

  context 'logged in as non-admin' do
    let(:super_admin_user) { create :super_admin_user }
    let!(:user) { create_logged_in_user }
    let(:admin_user) { create :admin_user }
    let(:second_user) { create :second_user }

    scenario 'attempting to view super-admin user profile: redirect to home page', js: true do
      visit user_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempting to view admin user profile: redirect to home page', js: true do
      visit user_path(admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'viewing own non-admin user profile: show own non-admin user profile page', js: true do
      visit user_path(user)
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_button('Edit User')
      expect(page).not_to have_button('Edit Admin Status')
      expect(page).to have_button('Delete User')
      expect(current_path).to eq user_path(user)
    end

    scenario 'attempting to view another non-admin user profile: redirect to home page', js: true do
      visit user_path(second_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'not logged in' do
    let!(:user) { create :user }

    scenario 'redirect to log in page', js: true do
      visit user_path(user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq log_in_path
    end
  end
end
