require 'rails_helper'

feature 'User log in' do
  context 'valid details' do
    let!(:user) { create :user }
    scenario 'redirect to user page with success message', js: true do
      visit login_path
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(user.id))
      expect(page).not_to have_link('Log out', href: logout_path)
      fill_in 'session_email',    with: "#{user.email}"
      fill_in 'session_password', with: "#{user.password}"
      click_button 'Log in'
      expect(page).to have_css 'div.alert-success'
      expect(page).not_to have_css 'div.alert-error'
      expect(page).to have_link('Profile', href: user_path(user.id))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).not_to have_link('Log in', href: login_path)
      expect(current_path).to eq user_path(user)
    end
  end

  context 'invalid details' do
    let(:invalid_user) { attributes_for :invalid_user }
    scenario 're-render form with error message', js: true do
      visit login_path
      fill_in 'session_email',    with: "#{invalid_user[:email]}"
      fill_in 'session_password', with: "#{invalid_user[:password]}"
      click_button 'Log in'
      expect(page).to have_css 'div.alert-error'
      expect(page).not_to have_css 'div.alert-success'
      expect(current_path).to eq login_path
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: logout_path)
      visit root_path
      expect(page).not_to have_css 'div.alert-error'
    end
  end
end

feature 'User log out' do
  context 'having been logged in' do
    let!(:user) { create_logged_in_user }
    scenario 'redirect to home page with success message', js: true do
      click_link 'Log out'
      expect(page).to have_css 'div.alert-success'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(user.id))
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
        expect(page).not_to have_link('Profile', href: user_path(user.id))
        expect(page).not_to have_link('Log out', href: logout_path)
        expect(current_path).to eq root_path
      end
    end
  end
end

feature 'Remembering user across sessions' do
  context 'opting to be remembered' do
    let!(:user) { create :user }
    scenario 'remember user after closing and re-opening browser', js: true do
      visit login_path
      fill_in 'session_email',    with: "#{user.email}"
      fill_in 'session_password', with: "#{user.password}"
      find(:css, '#session_remember_me').set true
      click_button 'Log in'
      expire_cookies
      visit root_path
      expect(page).to have_link('Profile', href: user_path(user.id))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).not_to have_link('Log in', href: login_path)
    end
  end

  context 'not opting to be remembered' do
    let!(:user) { create_logged_in_user }
    scenario 'remember user after closing and re-opening browser', js: true do
      expire_cookies
      visit root_path
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(user.id))
      expect(page).not_to have_link('Log out', href: logout_path)
    end
  end
end

feature 'friendly forwarding' do
  context 'attempt to visit page not logged in; logging in redirects to intended page first time only' do
    let(:user) { create :user }
    scenario 'redirect to login page', js: true do
      visit edit_user_path(user)
      fill_in 'session_email',    with: "#{user.email}"
      fill_in 'session_password', with: "#{user.password}"
      click_button 'Log in'
      expect(current_path).to eq edit_user_path(user)
      click_link 'Log out'
      visit login_path
      fill_in 'session_email',    with: "#{user.email}"
      fill_in 'session_password', with: "#{user.password}"
      click_button 'Log in'
      expect(current_path).to eq user_path(user)
    end
  end
end