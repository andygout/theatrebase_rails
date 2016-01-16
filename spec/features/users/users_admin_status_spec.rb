require 'rails_helper'

feature 'User edit/update admin status' do
  context 'logged in as super-admin user; attempt edit admin status of another user' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:second_super_admin_user) { create :second_super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }

    scenario 'attempt edit self (super-admin user): fail and redirect to home page', js: true do
      visit edit_admin_status_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit another super-admin user: fail and redirect to home page', js: true do
      visit edit_admin_status_path(second_super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit admin user: render admin user admin status edit form', js: true do
      visit edit_admin_status_path(admin_user)
      expect(current_path).to eq edit_admin_status_path(admin_user)
    end

    scenario 'attempt edit non-admin user: render non-admin user admin status edit form', js: true do
      visit edit_admin_status_path(user)
      expect(current_path).to eq edit_admin_status_path(user)
    end
  end

  context 'logged in as admin user; attempt edit admin status of another user' do
    let!(:admin_user) { create_logged_in_admin_user }
    let(:super_admin_user) { create :super_admin_user }
    let(:second_admin_user) { create :second_admin_user }
    let(:user) { create :user }

    scenario 'attempt edit admin status of super-admin user: fail and redirect to home page', js: true do
      visit edit_admin_status_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit admin status of self (admin user): fail and redirect to home page', js: true do
      visit edit_admin_status_path(admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit admin status of another admin user: fail and redirect to home page', js: true do
      visit edit_admin_status_path(second_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit admin status of non-admin user: fail and redirect to home page', js: true do
      visit edit_admin_status_path(user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'logged in as non-admin user; attempt edit admin status of another user' do
    let!(:user) { create_logged_in_user }
    let(:super_admin_user) { create :super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:second_user) { create :second_user }

    scenario 'attempt edit admin status of super-admin user: fail and redirect to home page', js: true do
      visit edit_admin_status_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit admin status of admin user: fail and redirect to home page', js: true do
      visit edit_admin_status_path(admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit admin status of self (non-admin user): fail and redirect to home page', js: true do
      visit edit_admin_status_path(user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt edit admin status of another non-admin user: fail and redirect to home page', js: true do
      visit edit_admin_status_path(second_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'not logged in; attempt edit admin status of another user' do
    let(:user) { create :user }

    scenario 'fail and redirect to log in page', js: true do
      visit edit_admin_status_path(user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq log_in_path
    end
  end

  context 'accessing permitted user admin status edit form' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:user) { create :user }

    scenario 'click on \'Edit Admin Status\' button on user profile page; display user edit form' do
      visit user_path(user)
      click_button 'Edit Admin Status'
      expect(current_path).to eq edit_admin_status_path(user)
    end
  end

  context 'updating admin status of permitted user profile' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:user) { create :user }
    let(:second_user) { create :second_user }

    before(:each) do
      visit edit_admin_status_path(user)
    end

    scenario 'successful update; redirect to user profile with success message', js: true do
      click_button 'Update Admin Status'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(user.admin.status).to eq false
      expect(current_path).to eq user_path(user)
      visit edit_admin_status_path(user)
      check('status')
      click_button 'Update Admin Status'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(User.find(user.id).admin.status).to eq true
      expect(current_path).to eq user_path(user)
      visit edit_admin_status_path(user)
      uncheck('status')
      click_button 'Update Admin Status'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(User.find(user.id).admin.status).to eq false
      expect(current_path).to eq user_path(user)
    end

    scenario 'after admin status is updated (set to true) only new admin status applies', js: true do
      check('status')
      click_button 'Update Admin Status'
      click_link 'Log out'
      log_in user
      visit user_path(second_user)
      expect(page).to have_content second_user.name
      expect(page).to have_content second_user.email
      expect(page).to have_button('Delete User')
      expect(page).not_to have_button('Edit Admin Status')
      expect(page).not_to have_button('Edit User')
      expect(current_path).to eq user_path(second_user)
    end

    scenario 'after admin status is updated (set to false) only new admin status applies', js: true do
      click_button 'Update Admin Status'
      click_link 'Log out'
      log_in user
      visit user_path(second_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end
end
