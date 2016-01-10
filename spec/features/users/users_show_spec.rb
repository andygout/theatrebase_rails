require 'rails_helper'

feature 'User profile' do
  context 'logged in as super-admin' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:second_super_admin_user) { create :second_super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }

    scenario 'viewing own user profile: display page', js: true do
      visit user_path(super_admin_user)
      expect(page).to have_content super_admin_user.name
      expect(page).to have_content super_admin_user.email
      expect(page).to have_button('Edit Profile')
      expect(page).not_to have_button('Edit Permissions')
      expect(page).not_to have_button('Delete User')
      expect(current_path).to eq user_path(super_admin_user)
    end

    scenario 'viewing other super-admin user profile: display page', js: true do
      visit user_path(second_super_admin_user)
      expect(page).to have_content second_super_admin_user.name
      expect(page).to have_content second_super_admin_user.email
      expect(page).not_to have_button('Edit Profile')
      expect(page).not_to have_button('Edit Permissions')
      expect(page).not_to have_button('Delete User')
      expect(current_path).to eq user_path(second_super_admin_user)
    end

    scenario 'viewing admin user profile: display page', js: true do
      visit user_path(admin_user)
      expect(page).to have_content admin_user.name
      expect(page).to have_content admin_user.email
      expect(page).not_to have_button('Edit Profile')
      expect(page).to have_button('Edit Permissions')
      expect(page).to have_button('Delete User')
      expect(current_path).to eq user_path(admin_user)
    end

    scenario 'viewing non-admin user profile: display page', js: true do
      visit user_path(user)
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_button('Delete User')
      expect(page).to have_button('Edit Permissions')
      expect(page).not_to have_button('Edit Profile')
      expect(current_path).to eq user_path(user)
    end
  end

  context 'logged in as admin' do
    let(:super_admin_user) { create :super_admin_user }
    let!(:admin_user) { create_logged_in_admin_user }
    let(:second_admin_user) { create :second_admin_user }
    let(:user) { create :user }

    scenario 'viewing super-admin user profile: display page', js: true do
      visit user_path(super_admin_user)
      expect(page).to have_content super_admin_user.name
      expect(page).to have_content super_admin_user.email
      expect(page).not_to have_button('Edit Profile')
      expect(page).not_to have_button('Edit Permissions')
      expect(page).not_to have_button('Delete User')
      expect(current_path).to eq user_path(super_admin_user)
    end

    scenario 'viewing own user profile: display page', js: true do
      visit user_path(admin_user)
      expect(page).to have_content admin_user.name
      expect(page).to have_content admin_user.email
      expect(page).to have_button('Edit Profile')
      expect(page).not_to have_button('Edit Permissions')
      expect(page).to have_button('Delete User')
      expect(current_path).to eq user_path(admin_user)
    end

    scenario 'viewing other admin user profile: display page', js: true do
      visit user_path(second_admin_user)
      expect(page).to have_content second_admin_user.name
      expect(page).to have_content second_admin_user.email
      expect(page).not_to have_button('Edit Profile')
      expect(page).not_to have_button('Edit Permissions')
      expect(page).not_to have_button('Delete User')
      expect(current_path).to eq user_path(second_admin_user)
    end

    scenario 'viewing non-admin user profile: display page', js: true do
      visit user_path(user)
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_button('Delete User')
      expect(page).not_to have_button('Edit Permissions')
      expect(page).not_to have_button('Edit Profile')
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

    scenario 'viewing own profile: display page', js: true do
      visit user_path(user)
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_button('Edit Profile')
      expect(page).not_to have_button('Edit Permissions')
      expect(page).to have_button('Delete User')
      expect(current_path).to eq user_path(user)
    end

    scenario 'attempting to view other non-admin user profile: redirect to home page', js: true do
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

  context 'friendly forwarding: logging in redirects to intended user profile page (if permitted)' do
    let(:super_admin_user) { create :super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }
    let(:second_user) { create :second_user }

    scenario 'log in as super-admin; redirect to own user profile page (permitted)', js: true do
      visit user_path(super_admin_user)
      log_in super_admin_user
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(current_path).to eq user_path(super_admin_user)
    end

    scenario 'log in as admin; redirect to own user profile page (permitted)', js: true do
      visit user_path(admin_user)
      log_in admin_user
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(current_path).to eq user_path(admin_user)
    end

    scenario 'log in as non-admin; redirect to own user profile page (permitted)', js: true do
      visit user_path(user)
      log_in user
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(current_path).to eq user_path(user)
    end

    scenario 'log in as non-admin; redirect to home page (other non-admin user profile page not permitted)', js: true do
      visit user_path(second_user)
      log_in user
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq root_path
    end
  end
end
