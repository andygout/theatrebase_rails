require 'rails_helper'

feature 'User edit/update' do
  context 'logged in as super-admin user; attempt edit another user' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:second_super_admin_user) { create :second_super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }

    scenario 'attempt edit self (super-admin user): render super-admin user edit form', js: true do
      visit edit_user_path(super_admin_user)
      expect(page).to have_current_path edit_user_path(super_admin_user)
    end

    scenario 'attempt edit another super-admin user: fail and redirect to home page', js: true do
      visit edit_user_path(second_super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit admin user: fail and redirect to home page', js: true do
      visit edit_user_path(admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit non-admin user: fail and redirect to home page', js: true do
      visit edit_user_path(user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end
  end

  context 'logged in as admin user; attempt edit another user' do
    let!(:admin_user) { create_logged_in_admin_user }
    let(:super_admin_user) { create :super_admin_user }
    let(:second_admin_user) { create :second_admin_user }
    let(:user) { create :user }

    scenario 'attempt edit super-admin user: fail and redirect to home page', js: true do
      visit edit_user_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit self (admin user): render admin user edit form', js: true do
      visit edit_user_path(admin_user)
      expect(page).to have_current_path edit_user_path(admin_user)
    end

    scenario 'attempt edit another admin user: fail and redirect to home page', js: true do
      visit edit_user_path(second_admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit non-admin user: fail and redirect to home page', js: true do
      visit edit_user_path(user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end
  end

  context 'logged in as non-admin user; attempt edit another user' do
    let!(:user) { create_logged_in_user }
    let(:super_admin_user) { create :super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:second_user) { create :second_user }

    scenario 'attempt edit super-admin user: fail and redirect to home page', js: true do
      visit edit_user_path(super_admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit admin user: fail and redirect to home page', js: true do
      visit edit_user_path(admin_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end

    scenario 'attempt edit self (non-admin user): render non-admin user edit form', js: true do
      visit edit_user_path(user)
      expect(page).to have_current_path edit_user_path(user)
    end

    scenario 'attempt edit another non-admin user: fail and redirect to home page', js: true do
      visit edit_user_path(second_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end
  end

  context 'not logged in; attempt edit another user' do
    let(:user) { create :user }

    scenario 'fail and redirect to log in page', js: true do
      visit edit_user_path(user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path log_in_path
    end
  end

  context 'accessing permitted user edit form' do
    let(:user) { create_logged_in_user }

    scenario 'click on \'Edit User\' button on user profile page; display user edit form' do
      visit user_path(user)
      click_button 'Edit User'
      expect(page).to have_current_path edit_user_path(user)
    end
  end

  context 'updating permitted user profile with valid details' do
    let(:created_user) { create :created_user }
    let(:edit_user) { attributes_for :edit_user }

    before(:each) do
      log_in created_user
      visit edit_user_path(created_user)
    end

    scenario 'valid details (inc. new password); redirect to user profile with success message', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      edit_user[:password],
                      edit_user[:password])
      click_button 'Update User'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_content(edit_user[:name])
      expect(page).to have_current_path user_path(created_user)
    end

    scenario 'valid details; existing creator association remains and updater association (w/itself) updated', js: true do
      user = created_user.creator
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      edit_user[:password],
                      edit_user[:password])
      click_button 'Update User'
      expect(created_user.reload.creator).to eq user
      expect(created_user.updater).to eq created_user
      expect(user.created_users).to include created_user
      expect(created_user.updated_users).to include created_user
      expect(user.updated_users).to be_empty
    end

    scenario 'after email and password are updated only new details can be used', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      edit_user[:password],
                      edit_user[:password])
      click_button 'Update User'
      click_link 'Log out'
      log_in created_user
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_current_path log_in_path
      fill_in 'session_email',    with: edit_user[:email]
      fill_in 'session_password', with: edit_user[:password]
      click_button 'Log In'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(created_user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(page).to have_current_path user_path(created_user)
    end

    scenario 'valid details (retaining existing password); redirect to user profile with success message', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      '',
                      '')
      click_button 'Update User'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_current_path user_path(created_user)
    end

    scenario 'if existing password is retained it can still be used', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      '',
                      '')
      click_button 'Update User'
      click_link 'Log out'
      visit log_in_path
      fill_in 'session_email',    with: edit_user[:email]
      fill_in 'session_password', with: created_user.password
      click_button 'Log In'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(created_user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(page).to have_current_path user_path(created_user)
    end
  end

  context 'updating permitted profile with invalid details; all re-render form with error message' do
    let(:created_user) { create :created_user }
    let(:edit_user) { attributes_for :edit_user }
    let(:invalid_user) { attributes_for :invalid_user }

    before(:each) do
      log_in created_user
      visit edit_user_path(created_user)
    end

    scenario 're-rendered user edit form should display existing user name', js: true do
      user_edit_form( invalid_user[:name],
                      invalid_user[:email],
                      invalid_user[:password],
                      invalid_user[:password])
      click_button 'Update User'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content created_user.name
      expect(page).to have_current_path user_path(created_user)
    end

    scenario 'invalid name', js: true do
      user_edit_form( invalid_user[:name],
                      edit_user[:email],
                      edit_user[:password],
                      edit_user[:password])
      click_button 'Update User'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_current_path user_path(created_user)
    end

    scenario 'invalid email', js: true do
      user_edit_form( edit_user[:name],
                      invalid_user[:email],
                      edit_user[:password],
                      edit_user[:password])
      click_button 'Update User'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_current_path user_path(created_user)
    end

    scenario 'password as single whitespace (with no confirmation)', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      ' ',
                      '')
      click_button 'Update User'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_current_path user_path(created_user)
    end

    scenario 'password and confirmation too short', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      'foo',
                      'foo')
      click_button 'Update User'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_current_path user_path(created_user)
    end

    scenario 'non-matching password and confirmation', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      'foobar',
                      'barfoo')
      click_button 'Update User'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_current_path user_path(created_user)
    end

    scenario 'invalid details; existing creator and updater associations remain', js: true do
      user = created_user.creator
      user_edit_form( invalid_user[:name],
                      invalid_user[:email],
                      'foo',
                      'bar')
      click_button 'Update User'
      expect(created_user.reload.creator).to eq user
      expect(created_user.updater).to eq user
      expect(user.created_users).to include created_user
      expect(user.updated_users).to include created_user
      expect(created_user.updated_users).to be_empty
    end
  end
end
