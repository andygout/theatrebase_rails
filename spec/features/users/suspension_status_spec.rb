require 'rails_helper'

feature 'User edit/update suspension status' do
  context 'attempt edit suspension status of user' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:second_super_admin_user) { create :second_super_admin_user }
    let(:user) { create :user }

    scenario 'attempt edit permitted user: render suspension status edit page', js: true do
      visit edit_suspension_status_path(user)
      expect(page).to have_current_path edit_suspension_status_path(user)
    end

    scenario 'attempt edit unpermitted user: fail and redirect to home page', js: true do
      visit edit_suspension_status_path(second_super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
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
    let(:user_attrs) { attributes_for :user }
    let(:super_admin_user) { create :super_admin_user }

    scenario 'user will be logged out on first page request following suspension', js: true do
      visit edit_user_path(user)
      user_edit_form( user_attrs[:name],
                      user_attrs[:email],
                      user_attrs[:password],
                      user_attrs[:password])
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
