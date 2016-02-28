require 'rails_helper'

feature 'User edit/update suspension status' do
  context 'logged in as super-admin user; attempt edit suspension status of another user' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:second_super_admin_user) { create :second_super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }

    scenario 'attempt edit self (super-admin user): fail and redirect to home page', js: true do
      visit edit_suspension_status_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit another super-admin user: fail and redirect to home page', js: true do
      visit edit_suspension_status_path(second_super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit admin user: render admin user suspension status edit form', js: true do
      visit edit_suspension_status_path(admin_user)
      expect(page).to have_current_path edit_suspension_status_path(admin_user)
    end

    scenario 'attempt edit non-admin user: render non-admin user suspension status edit form', js: true do
      visit edit_suspension_status_path(user)
      expect(page).to have_current_path edit_suspension_status_path(user)
    end
  end

  context 'logged in as admin user; attempt edit suspension status of another user' do
    let!(:admin_user) { create_logged_in_admin_user }
    let(:super_admin_user) { create :super_admin_user }
    let(:second_admin_user) { create :second_admin_user }
    let(:user) { create :user }

    scenario 'attempt edit super-admin user: fail and redirect to home page', js: true do
      visit edit_suspension_status_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit self (admin user): fail and redirect to home page', js: true do
      visit edit_suspension_status_path(admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit another admin user: fail and redirect to home page', js: true do
      visit edit_suspension_status_path(second_admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit non-admin user: fail and redirect to home page', js: true do
      visit edit_suspension_status_path(user)
      expect(page).to have_current_path edit_suspension_status_path(user)
    end
  end

  context 'logged in as non-admin user; attempt edit suspension status of another user' do
    let!(:user) { create_logged_in_user }
    let(:super_admin_user) { create :super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:second_user) { create :second_user }

    scenario 'attempt edit super-admin user: fail and redirect to home page', js: true do
      visit edit_suspension_status_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit admin user: fail and redirect to home page', js: true do
      visit edit_suspension_status_path(admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit self (non-admin user): fail and redirect to home page', js: true do
      visit edit_suspension_status_path(user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit another non-admin user: fail and redirect to home page', js: true do
      visit edit_suspension_status_path(second_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end
  end

  context 'not logged in; attempt edit suspension status of another user' do
    let(:user) { create :user }

    scenario 'fail and redirect to log in page', js: true do
      visit edit_suspension_status_path(user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path log_in_path
    end
  end

  context 'accessing permitted user suspension status edit form' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:user) { create :user }

    scenario 'click on \'Edit Suspension Status\' button on user profile page; display user edit form' do
      visit user_path(user)
      click_button 'Edit Suspension Status'
      expect(page).to have_current_path edit_suspension_status_path(user)
    end
  end

  context 'updating suspension status of permitted user profile' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:user) { create :user }

    before(:each) do
      visit edit_suspension_status_path(user)
    end

    scenario 'successful update; redirect to user profile with success message', js: true do
      click_button 'Update Suspension Status'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(user.suspension).to be nil
      expect(page).to have_current_path user_path(user)
      visit edit_suspension_status_path(user)
      check('status')
      click_button 'Update Suspension Status'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(user.reload.suspension).not_to be nil
      expect(page).to have_current_path user_path(user)
      visit edit_suspension_status_path(user)
      uncheck('status')
      click_button 'Update Suspension Status'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(user.reload.suspension).to be nil
      expect(page).to have_current_path user_path(user)
    end

    scenario 'assignor and assignee associations created/destroyed', js: true do
      check('status')
      click_button 'Update Suspension Status'
      expect(user.suspension_status_assignor).to eq(super_admin_user)
      expect(super_admin_user.suspension_status_assignees).to include(user)
      visit edit_suspension_status_path(user)
      uncheck('status')
      click_button 'Update Suspension Status'
      expect(user.reload.suspension_status_assignor).to eq(nil)
      expect(super_admin_user.suspension_status_assignees).to be_empty
    end

    scenario 'after suspension status is updated only new suspension status applies', js: true do
      check('status')
      click_button 'Update Suspension Status'
      click_link 'Log out'
      log_in user
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_link('Profile', href: user_path(user))
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).to have_current_path root_path
      log_in super_admin_user
      visit edit_suspension_status_path(user)
      uncheck('status')
      click_button 'Update Suspension Status'
      click_link 'Log out'
      log_in user
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(page).to have_current_path user_path(user)
    end
  end

  context 'logged in as user whose account is suspended' do
    let(:user) { create_logged_in_user }
    let(:edit_user) { attributes_for :edit_user }
    let(:super_admin_user) { create :super_admin_user }

    scenario 'user will be logged out on first page request following suspension', js: true do
      visit edit_user_path(user)
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      edit_user[:password],
                      edit_user[:password])
      Suspension.create(user_id: user.id, assignor_id: super_admin_user.id)
      click_button 'Update User'
      expect(user.name).to eq user.reload.name
      expect(page).to have_css '.alert-error'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_current_path root_path
    end
  end
end
