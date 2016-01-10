require 'rails_helper'

feature 'User edit/update permissions' do
  context 'logged in as super-admin user; attempt edit permissions of another user' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:second_super_admin_user) { create :second_super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }

    scenario 'attempt edit self (super-admin user): fail and redirect to home page', js: true do
      visit edit_permission_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit another super-admin user: fail and redirect to home page', js: true do
      visit edit_permission_path(second_super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit admin user: render admin user permission edit form', js: true do
      visit edit_permission_path(admin_user)
      expect(current_path).to eq edit_permission_path(admin_user)
    end

    scenario 'attempt edit non-admin user: render non-admin user permission edit form', js: true do
      visit edit_permission_path(user)
      expect(current_path).to eq edit_permission_path(user)
    end
  end

  context 'logged in as admin user; attempt edit permissions of another user' do
    let!(:admin_user) { create_logged_in_admin_user }
    let(:super_admin_user) { create :super_admin_user }
    let(:second_admin_user) { create :second_admin_user }
    let(:user) { create :user }

    scenario 'attempt edit permissions of super-admin user: fail and redirect to home page', js: true do
      visit edit_permission_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit permissions of self (admin user): fail and redirect to home page', js: true do
      visit edit_permission_path(admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit permissions of another admin user: fail and redirect to home page', js: true do
      visit edit_permission_path(second_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit permissions of non-admin user: fail and redirect to home page', js: true do
      visit edit_permission_path(user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'logged in as non-admin user; attempt edit permissions of another user' do
    let!(:user) { create_logged_in_user }
    let(:super_admin_user) { create :super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:second_user) { create :second_user }

    scenario 'attempt edit permissions of super-admin user: fail and redirect to home page', js: true do
      visit edit_permission_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit permissions of admin user: fail and redirect to home page', js: true do
      visit edit_permission_path(admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit permissions of self (non-admin user): fail and redirect to home page', js: true do
      visit edit_permission_path(user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit permissions of another non-admin user: fail and redirect to home page', js: true do
      visit edit_permission_path(second_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'not logged in; attempt edit permissions of another user' do
    let(:user) { create :user }

    scenario 'fail and redirect to log in page', js: true do
      visit edit_permission_path(user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq log_in_path
    end
  end

  context 'updating permissions of permitted user profile' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:user) { create :user }
    let(:second_user) { create :second_user }

    scenario 'using button to access edit user permissions form', js: true do
      visit user_path(user)
      click_button 'Edit Permissions'
      expect(current_path).to eq edit_permission_path(user)
    end

    scenario 'successful update; redirect to user profile with success message', js: true do
      visit edit_permission_path(user)
      click_button 'Update Permissions'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(user.admin.status).to eq false
      expect(current_path).to eq user_path(user)
      visit edit_permission_path(user)
      check('status')
      click_button 'Update Permissions'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(User.find(user.id).admin.status).to eq true
      expect(current_path).to eq user_path(user)
      visit edit_permission_path(user)
      uncheck('status')
      click_button 'Update Permissions'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(User.find(user.id).admin.status).to eq false
      expect(current_path).to eq user_path(user)
    end

    scenario 'after permissions are updated only new permissions apply (admin status set to true)', js: true do
      visit edit_permission_path(user)
      check('status')
      click_button 'Update Permissions'
      click_link 'Log out'
      log_in user
      visit user_path(second_user)
      expect(page).to have_content second_user.name
      expect(page).to have_content second_user.email
      expect(page).to have_button('Delete User')
      expect(page).not_to have_button('Edit Permissions')
      expect(page).not_to have_button('Edit Profile')
      expect(current_path).to eq user_path(second_user)
    end

    scenario 'after permissions are updated only new permissions apply (admin status set to false)', js: true do
      visit edit_permission_path(user)
      click_button 'Update Permissions'
      click_link 'Log out'
      log_in user
      visit user_path(second_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end
end
