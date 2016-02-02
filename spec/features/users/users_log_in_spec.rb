require 'rails_helper'

feature 'User log in' do
  let(:user) { create :user }
  let(:second_user) { attributes_for :second_user }

  context 'valid details' do
    scenario 'redirect to user page with success message', js: true do
      visit log_in_path
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile', href: user_path(user))
      expect(page).not_to have_link('Log out', href: log_out_path)
      log_in user
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(current_path).to eq user_path(user)
    end
  end

  context 'invalid details; all re-render form with error message' do
    before(:each) do
      visit log_in_path
    end

    scenario 'details of non-existing user', js: true do
      fill_in 'session_email',    with: second_user[:email]
      fill_in 'session_password', with: second_user[:password]
      click_button 'Log In'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(current_path).to eq log_in_path
    end

    scenario 'correct email address but incorrect password', js: true do
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: 'incorrect-password'
      click_button 'Log In'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(current_path).to eq log_in_path
    end

    scenario 'correct password but incorrect email address', js: true do
      fill_in 'session_email',    with: 'incorrect@example.com'
      fill_in 'session_password', with: user.password
      click_button 'Log In'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(current_path).to eq log_in_path
    end

    scenario 'error alert will disappear when visiting subsequent page', js: true do
      fill_in 'session_email',    with: second_user[:email]
      fill_in 'session_password', with: second_user[:password]
      click_button 'Log In'
      visit root_path
      expect(page).not_to have_css '.alert-error'
    end
  end
end

feature 'User log out' do
  let!(:user) { create_logged_in_user }

  context 'having been logged in' do
    scenario 'redirect to home page with success message', js: true do
      click_link 'Log out'
      expect(page).to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile', href: user_path(user))
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(current_path).to eq root_path
    end
  end

  context 'having been logged in; logging out from second window' do
    scenario 'redirect to home page if logging out from second window', js:true do
      new_window = open_new_window
      within_window new_window do
        visit root_path
      end
      click_link 'Log out'
      within_window new_window do
        click_link 'Log out'
        expect(page).to have_link('Log in', href: log_in_path)
        expect(page).not_to have_link('Profile', href: user_path(user))
        expect(page).not_to have_link('Log out', href: log_out_path)
        expect(current_path).to eq root_path
      end
    end
  end
end

feature 'Remembering user across sessions' do
  context 'opting to be remembered' do
    let(:user) { create :user }

    scenario 'remember user after closing and re-opening browser', js: true do
      visit log_in_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      find(:css, '#session_remember_me').set true
      click_button 'Log In'
      expire_cookies
      visit root_path
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(user.reload.remember_created_at).not_to eq(nil)
    end
  end

  context 'not opting to be remembered' do
    let!(:user) { create_logged_in_user }

    scenario 'remember user after closing and re-opening browser', js: true do
      expire_cookies
      visit root_path
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile', href: user_path(user))
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(user.reload.remember_created_at).to eq(nil)
    end
  end
end

feature '\'Remember created at\' time' do
  let(:user) { create :user }

  context 'user logs in' do
    scenario 'value will be set and reset on subsequent log ins', js: true do
      expect(user.reload.remember_created_at).to eq(nil)
      log_in user
      expect(user.reload.remember_created_at).to eq(nil)
      click_link 'Log out'
      visit log_in_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      find(:css, '#session_remember_me').set true
      click_button 'Log In'
      expect(user.reload.remember_created_at).not_to eq(nil)
      first_remember_created_at_time = user.reload.remember_created_at
      click_link 'Log out'
      visit log_in_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      find(:css, '#session_remember_me').set true
      click_button 'Log In'
      expect(user.reload.remember_created_at).not_to eq(nil)
      second_remember_created_at_time = user.reload.remember_created_at
      expect(first_remember_created_at_time).not_to eq(second_remember_created_at_time)
    end
  end
end

feature '\'Current log in at\'/\'Last log in at\' times' do
  let(:user) { create :user }

  context 'user logs in' do
    scenario 'values will be set and reset on subsequent log ins', js: true do
      expect(user.reload.current_log_in_at).to eq(nil)
      expect(user.reload.last_log_in_at).to eq(nil)
      log_in user
      first_current_log_in_at_time = user.reload.current_log_in_at
      expect(first_current_log_in_at_time).not_to eq(nil)
      expect(user.reload.last_log_in_at).to eq(nil)
      click_link 'Log out'
      log_in user
      second_current_log_in_at_time = user.reload.current_log_in_at
      first_last_log_in_at_time = user.reload.last_log_in_at
      expect(second_current_log_in_at_time).not_to eq(nil)
      expect(first_current_log_in_at_time).to eq(first_last_log_in_at_time)
      expect(first_current_log_in_at_time).not_to eq(second_current_log_in_at_time)
      click_link 'Log out'
      log_in user
      second_last_log_in_at_time = user.reload.last_log_in_at
      expect(first_last_log_in_at_time).not_to eq(second_last_log_in_at_time)
      expect(second_current_log_in_at_time).to eq(second_last_log_in_at_time)
    end
  end
end

feature 'Log in count' do
  let(:user) { create :user }

  context 'user logs in' do
    scenario 'value will be incremented on each log in', js: true do
      expect(user.reload.log_in_count).to eq(nil)
      log_in user
      expect(user.reload.log_in_count).to eq(1)
      click_link 'Log out'
      log_in user
      expect { log_in user }.to change { user.reload.log_in_count }.by 1
    end
  end
end

feature 'Friendly forwarding' do
  let(:user) { create :user }
  let(:second_user) { create :second_user }

  context 'attempt to visit permitted page not logged in; logging in redirects to intended page first time only' do
    scenario 'redirect to log in page', js: true do
      visit edit_user_path(user)
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      click_button 'Log In'
      expect(current_path).to eq edit_user_path(user)
      click_link 'Log out'
      visit log_in_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      click_button 'Log In'
      expect(current_path).to eq user_path(user)
    end
  end

  context 'attempt to visit unpermitted page not logged in; logging in redirects to unpermitted alert page first time only' do
    scenario 'redirect to log in page', js: true do
      visit edit_user_path(second_user)
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      click_button 'Log In'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq root_path
      click_link 'Log out'
      visit log_in_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      click_button 'Log In'
      expect(current_path).to eq user_path(user)
    end
  end
end
