require 'rails_helper'

feature 'User log in' do
  context 'valid details' do
    let(:user) { create :user }

    scenario 'redirect to user page with success message', js: true do
      visit login_path
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(user))
      expect(page).not_to have_link('Log out', href: logout_path)
      login user
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).not_to have_link('Log in', href: login_path)
      expect(current_path).to eq user_path(user)
    end
  end

  context 'invalid details; all re-render form with error message' do
    before(:each) do
      visit login_path
    end

    let(:user) { create :user }
    let(:second_user) { attributes_for :second_user }

    scenario 'details of non-existing user', js: true do
      fill_in 'session_email',    with: second_user[:email]
      fill_in 'session_password', with: second_user[:password]
      click_button 'Log in'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq login_path
    end

    scenario 'correct email address but incorrect password', js: true do
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: 'incorrect-password'
      click_button 'Log in'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq login_path
    end

    scenario 'correct password but incorrect email address', js: true do
      fill_in 'session_email',    with: 'incorrect@example.com'
      fill_in 'session_password', with: user.password
      click_button 'Log in'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq login_path
    end

    scenario 'error alert will disappear when visiting subsequent page', js: true do
      fill_in 'session_email',    with: second_user[:email]
      fill_in 'session_password', with: second_user[:password]
      click_button 'Log in'
      visit root_path
      expect(page).not_to have_css '.alert-error'
    end
  end
end

feature 'User log out' do
  context 'having been logged in' do
    let!(:user) { create_logged_in_user }

    scenario 'redirect to home page with success message', js: true do
      click_link 'Log out'
      expect(page).to have_css '.alert-success'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(user))
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq root_path
    end
  end

  context 'having been logged in; logging out from second window' do
    let!(:user) { create_logged_in_user }

    scenario 'redirect to home page if logging out from second window', js:true do
      new_window = open_new_window
      within_window new_window do
        visit root_path
      end
      click_link 'Log out'
      within_window new_window do
        click_link 'Log out'
        expect(page).to have_link('Log in', href: login_path)
        expect(page).not_to have_link('Profile', href: user_path(user))
        expect(page).not_to have_link('Log out', href: logout_path)
        expect(current_path).to eq root_path
      end
    end
  end
end

feature 'Remembering user across sessions' do
  context 'opting to be remembered' do
    let(:user) { create :user }

    scenario 'remember user after closing and re-opening browser', js: true do
      visit login_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      find(:css, '#session_remember_me').set true
      click_button 'Log in'
      expire_cookies
      visit root_path
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).not_to have_link('Log in', href: login_path)
      expect(User.find(user.id).remember_created_at).not_to eq(nil)
    end
  end

  context 'not opting to be remembered' do
    let!(:user) { create_logged_in_user }

    scenario 'remember user after closing and re-opening browser', js: true do
      expire_cookies
      visit root_path
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(user))
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(User.find(user.id).remember_created_at).to eq(nil)
    end
  end
end

feature '\'Remember created at\' time' do
  context 'user logs in' do
    let(:user) { create :user }

    scenario 'value will be set and reset on subsequent log ins', js: true do
      expect(User.find(user.id).remember_created_at).to eq(nil)
      login user
      expect(User.find(user.id).remember_created_at).to eq(nil)
      click_link 'Log out'
      visit login_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      find(:css, '#session_remember_me').set true
      click_button 'Log in'
      expect(User.find(user.id).remember_created_at).not_to eq(nil)
      first_remember_created_at_time = User.find(user.id).remember_created_at
      click_link 'Log out'
      visit login_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      find(:css, '#session_remember_me').set true
      click_button 'Log in'
      expect(User.find(user.id).remember_created_at).not_to eq(nil)
      second_remember_created_at_time = User.find(user.id).remember_created_at
      expect(first_remember_created_at_time).not_to eq(second_remember_created_at_time)
    end
  end
end

feature 'Friendly forwarding' do
  context 'attempt to visit page not logged in; logging in redirects to intended page first time only' do
    let(:user) { create :user }

    scenario 'redirect to login page', js: true do
      visit edit_user_path(user)
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      click_button 'Log in'
      expect(current_path).to eq edit_user_path(user)
      click_link 'Log out'
      visit login_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      click_button 'Log in'
      expect(current_path).to eq user_path(user)
    end
  end
end
