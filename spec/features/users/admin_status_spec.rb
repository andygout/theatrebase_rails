require 'rails_helper'

feature 'User edit/update admin status' do
  context 'attempt edit admin status of user' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:second_super_admin_user) { create :second_super_admin_user }
    let(:user) { create :user }

    scenario 'attempt edit permitted user: render admin status edit page', js: true do
      visit edit_admin_status_path(user)
      expect(page).to have_current_path edit_admin_status_path(user)
    end

    scenario 'attempt edit unpermitted user: fail and redirect to home page', js: true do
      visit edit_admin_status_path(second_super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end
  end

  context 'accessing permitted user admin status edit form' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:user) { create :user }

    scenario 'click on \'Edit Admin Status\' button on user profile page; display user edit form' do
      visit user_path(user)
      click_button 'Edit Admin Status'
      expect(page).to have_current_path edit_admin_status_path(user)
    end
  end

  context 'updating admin status of permitted user profile' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:user) { create :user }
    let(:second_user) { create :user }

    before(:each) do
      visit edit_admin_status_path(user)
    end

    scenario 'successful update; redirect to user profile with success message', js: true do
      click_button 'Update Admin Status'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(user.admin).to be nil
      expect(page).to have_current_path user_path(user)
      visit edit_admin_status_path(user)
      check('status')
      click_button 'Update Admin Status'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(user.reload.admin).not_to be nil
      expect(page).to have_current_path user_path(user)
      visit edit_admin_status_path(user)
      uncheck('status')
      click_button 'Update Admin Status'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(user.reload.admin).to be nil
      expect(page).to have_current_path user_path(user)
    end

    scenario 'assignor and assignee associations created/destroyed', js: true do
      check('status')
      click_button 'Update Admin Status'
      expect(user.admin_status_assignor).to eq super_admin_user
      expect(super_admin_user.admin_status_assignees).to include user
      visit edit_admin_status_path(user)
      uncheck('status')
      click_button 'Update Admin Status'
      expect(user.reload.admin_status_assignor).to eq nil
      expect(super_admin_user.admin_status_assignees).to be_empty
    end

    scenario 'after admin status is updated only new admin status applies', js: true do
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
      expect(page).to have_current_path user_path(second_user)
      click_link 'Log out'
      log_in super_admin_user
      visit edit_admin_status_path(user)
      uncheck('status')
      click_button 'Update Admin Status'
      click_link 'Log out'
      log_in user
      visit user_path(second_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end
  end
end
