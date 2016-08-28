require 'rails_helper'

feature 'User edit/update' do
  context 'attempt edit user' do
    let!(:admin_user) { create_logged_in_admin_user }
    let(:user) { create :user }

    scenario 'attempt edit permitted user: render edit page', js: true do
      visit edit_user_path(admin_user)
      expect(page).to have_current_path edit_user_path(admin_user)
    end

    scenario 'attempt edit unpermitted user: fail and redirect to home page', js: true do
      visit edit_user_path(user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
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

  context 'displaying creator + updater info on edit form' do
    let(:user_with_creator) { create :user_with_creator }
    let(:user) { user_with_creator.creator }
    let(:user_attributes) { attributes_for :user }

    scenario 'creator and updater will only display as link if profile page accessible by user' do
      log_in user_with_creator
      visit edit_user_path(user_with_creator)
      expect(page).to have_content(user[:name])
      expect(page).not_to have_link(user[:name], href: user_path(user))
      fill_in 'user_name', with: user_attributes[:name]
      click_button 'Update User'
      user_with_creator.reload
      visit edit_user_path(user_with_creator)
      expect(page).to have_content(user_with_creator[:name])
      expect(page).to have_link(user_with_creator[:name], href: user_path(user_with_creator))
    end
  end

  context 'updating permitted user profile with valid details' do
    let(:user) { create :user }
    let(:user_attrs) { attributes_for :user }

    before(:each) do
      log_in user
      visit edit_user_path(user)
    end

    scenario 'valid details (inc. new password); redirect to user profile with success message', js: true do
      user_edit_form( user_attrs[:name],
                      user_attrs[:email],
                      user_attrs[:password],
                      user_attrs[:password])
      click_button 'Update User'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_content(user_attrs[:name])
      expect(page).to have_current_path user_path(user)
    end

    scenario 'once email and password updated only new details can be used', js: true do
      user_edit_form( user_attrs[:name],
                      user_attrs[:email],
                      user_attrs[:password],
                      user_attrs[:password])
      click_button 'Update User'
      click_link 'Log out'
      log_in user
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_current_path log_in_path
      fill_in 'session_email',    with: user_attrs[:email]
      fill_in 'session_password', with: user_attrs[:password]
      click_button 'Log In'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(page).to have_current_path user_path(user)
    end

    scenario 'password can contain leading and trailing whitespace', js: true do
      user_edit_form( user.name,
                      user.email,
                      " #{user_attrs[:password]} ",
                      " #{user_attrs[:password]} ")
      click_button 'Update User'
      click_link 'Log out'
      visit log_in_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user_attrs[:password]
      click_button 'Log In'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_current_path log_in_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: " #{user_attrs[:password]} "
      click_button 'Log In'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(page).to have_current_path user_path(user)
    end

    scenario 'valid details (retaining existing password); redirect to user profile with success message', js: true do
      user_edit_form( user_attrs[:name],
                      user_attrs[:email],
                      '',
                      '')
      click_button 'Update User'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_current_path user_path(user)
    end

    scenario 'if password is not given any update values then existing password will be retained', js: true do
      user_edit_form( user_attrs[:name],
                      user_attrs[:email],
                      '',
                      '')
      click_button 'Update User'
      click_link 'Log out'
      visit log_in_path
      fill_in 'session_email',    with: user_attrs[:email]
      fill_in 'session_password', with: user.password
      click_button 'Log In'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(page).to have_current_path user_path(user)
    end
  end

  context 'updating permitted profile with invalid details' do
    let(:user) { create :user }
    let(:invalid_user_attrs) { attributes_for :invalid_user }
    let(:user_attrs) { attributes_for :user }

    before(:each) do
      log_in user
      visit edit_user_path(user)
    end

    scenario 're-render form with error message, displaying existing user name', js: true do
      user_edit_form( invalid_user_attrs[:name],
                      invalid_user_attrs[:email],
                      invalid_user_attrs[:password],
                      invalid_user_attrs[:password])
      click_button 'Update User'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content user.name
      expect(page).to have_current_path user_path(user)
    end

    scenario 'enter password as single whitespace (with no confirmation); re-render form with error message', js: true do
      user_edit_form( user_attrs[:name],
                      user_attrs[:email],
                      ' ',
                      '')
      click_button 'Update User'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_current_path user_path(user)
    end
  end
end
