require 'rails_helper'

feature 'User edit/update' do
  context 'logged in as admin; updating own profile with valid details' do
    let(:admin_user) { create_logged_in_admin_user }
    let(:edit_user) { attributes_for :edit_user }

    before(:each) do
      visit edit_user_path(admin_user)
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
      expect(current_path).to eq user_path(admin_user)
    end

    scenario 'valid details; existing creator association remains and updater association (w/itself) updated', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      edit_user[:password],
                      edit_user[:password])
      click_button 'Update User'
      admin_user = User.find_by(email: edit_user[:email])
      expect(admin_user.creator).to eq(nil)
      expect(admin_user.updater).to eq(admin_user)
      expect(admin_user.created_users).to be_empty
      expect(admin_user.updated_users).to include(admin_user)
    end

    scenario 'after email and password are updated only new details can be used', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      edit_user[:password],
                      edit_user[:password])
      click_button 'Update User'
      click_link 'Log out'
      login admin_user
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq login_path
      fill_in 'session_email',    with: edit_user[:email]
      fill_in 'session_password', with: edit_user[:password]
      click_button 'Log in'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(admin_user))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).not_to have_link('Log in', href: login_path)
      expect(current_path).to eq user_path(admin_user)
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
      expect(current_path).to eq user_path(admin_user)
    end

    scenario 'if existing password is retained it can still be used', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      '',
                      '')
      click_button 'Update User'
      click_link 'Log out'
      visit login_path
      fill_in 'session_email',    with: edit_user[:email]
      fill_in 'session_password', with: admin_user.password
      click_button 'Log in'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(admin_user))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).not_to have_link('Log in', href: login_path)
      expect(current_path).to eq user_path(admin_user)
    end
  end

  context 'logged in as admin; updating own profile with invalid details; all re-render form with error message' do
    let(:admin_user) { create_logged_in_admin_user }
    let(:edit_user) { attributes_for :edit_user }
    let(:invalid_user) { attributes_for :invalid_user }

    before(:each) do
      visit edit_user_path(admin_user)
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
      expect(current_path).to eq user_path(admin_user)
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
      expect(current_path).to eq user_path(admin_user)
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
      expect(current_path).to eq user_path(admin_user)
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
      expect(current_path).to eq user_path(admin_user)
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
      expect(current_path).to eq user_path(admin_user)
    end

    scenario 'invalid details; existing creator and updater associations remain', js: true do
      user_edit_form( invalid_user[:name],
                      invalid_user[:email],
                      'foo',
                      'bar')
      click_button 'Update User'
      admin_user_copy = admin_user
      admin_user = User.find_by(email: admin_user_copy.email)
      expect(admin_user.creator).to eq(nil)
      expect(admin_user.updater).to eq(nil)
      expect(admin_user.created_users).to be_empty
      expect(admin_user.updated_users).to be_empty
    end
  end

  context 'logged in as admin; attempt to edit another user' do
    let(:second_admin_user) { create :second_admin_user }
    let(:user) { create :user }

    scenario 'attempt to edit another admin user: redirect to home page', js: true do
      create_logged_in_admin_user
      visit edit_user_path(second_admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt to edit a non-admin user: redirect to home page', js: true do
      create_logged_in_admin_user
      visit edit_user_path(user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'logged in as non-admin; updating own profile with valid details' do
    let(:user) { create_logged_in_user }
    let(:admin_user) { create :admin_user }
    let(:edit_user) { attributes_for :edit_user }

    before(:each) do
      visit edit_user_path(user)
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
      expect(current_path).to eq user_path(user)
    end

    scenario 'valid details; existing creator association remains and updater association (w/itself) updated', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      edit_user[:password],
                      edit_user[:password])
      click_button 'Update User'
      user = User.find_by(email: edit_user[:email])
      expect(user.creator).to eq(nil)
      expect(user.updater).to eq(user)
      expect(user.created_users).to be_empty
      expect(user.updated_users).to include(user)
    end

    scenario 'after email and password are updated only new details can be used', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      edit_user[:password],
                      edit_user[:password])
      click_button 'Update User'
      click_link 'Log out'
      login user
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq login_path
      fill_in 'session_email',    with: edit_user[:email]
      fill_in 'session_password', with: edit_user[:password]
      click_button 'Log in'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).not_to have_link('Log in', href: login_path)
      expect(current_path).to eq user_path(user)
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
      expect(current_path).to eq user_path(user)
    end

    scenario 'if existing password is retained it can still be used', js: true do
      user_edit_form( edit_user[:name],
                      edit_user[:email],
                      '',
                      '')
      click_button 'Update User'
      click_link 'Log out'
      visit login_path
      fill_in 'session_email',    with: edit_user[:email]
      fill_in 'session_password', with: user.password
      click_button 'Log in'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).not_to have_link('Log in', href: login_path)
      expect(current_path).to eq user_path(user)
    end
  end

  context 'logged in as non-admin; updating own profile with invalid details; all re-render form with error message' do
    let(:user) { create_logged_in_user }
    let(:edit_user) { attributes_for :edit_user }
    let(:invalid_user) { attributes_for :invalid_user }

    before(:each) do
      visit edit_user_path(user)
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
      expect(current_path).to eq user_path(user)
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
      expect(current_path).to eq user_path(user)
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
      expect(current_path).to eq user_path(user)
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
      expect(current_path).to eq user_path(user)
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
      expect(current_path).to eq user_path(user)
    end

    scenario 'invalid details; existing creator and updater associations remain', js: true do
      user_edit_form( invalid_user[:name],
                      invalid_user[:email],
                      'foo',
                      'bar')
      click_button 'Update User'
      user_copy = user
      user = User.find_by(email: user_copy.email)
      expect(user.creator).to eq(nil)
      expect(user.updater).to eq(nil)
      expect(user.created_users).to be_empty
      expect(user.updated_users).to be_empty
    end
  end

  context 'logged in as non-admin; attempt to edit another user' do
    let(:admin_user) { create :admin_user }
    let(:second_user) { create :second_user }

    scenario 'attempt to edit an admin user: redirect to home page', js: true do
      create_logged_in_user
      visit edit_user_path(admin_user)
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempt to edit another non-admin user: redirect to home page', js: true do
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
