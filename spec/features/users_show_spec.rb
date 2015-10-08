require 'rails_helper'

feature 'User profile' do
  context 'logged in as admin' do
    let!(:admin_user) { create_logged_in_admin_user }
    let(:second_admin_user) { create :second_admin_user }
    let(:user) { create :user }

    scenario 'viewing own user profile: display page', js: true do
      visit user_path(admin_user)
      expect(page).to have_content "#{admin_user.name}"
      expect(page).to have_content "#{admin_user.email}"
      expect(page).to have_link('Edit Profile', href: edit_user_path(admin_user))
      expect(page).to have_link('Delete User', href: user_path(admin_user))
      expect(current_path).to eq user_path(admin_user)
    end

    scenario 'viewing other admin user profile: display page', js: true do
      visit user_path(second_admin_user)
      expect(page).to have_content "#{second_admin_user.name}"
      expect(page).to have_content "#{second_admin_user.email}"
      expect(page).not_to have_link('Edit Profile', href: edit_user_path(second_admin_user))
      expect(page).not_to have_link('Delete User', href: user_path(second_admin_user))
      expect(current_path).to eq user_path(second_admin_user)
    end

    scenario 'viewing non-admin user profile: display page', js: true do
      visit user_path(user)
      expect(page).to have_content "#{user.name}"
      expect(page).to have_content "#{user.email}"
      expect(page).to have_link('Delete User', href: user_path(user))
      expect(page).not_to have_link('Edit Profile', href: edit_user_path(user))
      expect(current_path).to eq user_path(user)
    end
  end

  context 'logged in as non-admin' do
    let!(:user) { create_logged_in_user }
    let(:admin_user) { create :admin_user }
    let(:second_user) { create :second_user }

    scenario 'viewing own profile: display page', js: true do
      visit user_path(user)
      expect(page).to have_content "#{user.name}"
      expect(page).to have_content "#{user.email}"
      expect(page).to have_link('Edit Profile', href: edit_user_path(user))
      expect(page).to have_link('Delete User', href: user_path(user))
      expect(current_path).to eq user_path(user)
    end

    scenario 'attempting to view admin user profile: redirect to home page', js: true do
      visit user_path(admin_user)
      expect(page).to have_css 'div.alert-error'
      expect(current_path).to eq root_path
    end

    scenario 'attempting to view other non-admin user profile: redirect to home page', js: true do
      visit user_path(second_user)
      expect(page).to have_css 'div.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'not logged in' do
    let!(:user) { create :user }
    scenario 'redirect to login page', js: true do
      visit user_path(user)
      expect(page).to have_css 'div.alert-error'
      expect(current_path).to eq login_path
    end
  end

  context 'friendly forwarding: logging in redirects to intended user profile page (if permitted)' do
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }

    scenario 'log in as admin; redirect to own user profile page', js: true do
      visit user_path(admin_user)
      login admin_user
      expect(current_path).to eq user_path(admin_user)
      expect(page).to have_css 'div.alert-success'
      expect(page).not_to have_css 'div.alert-error'
    end

    scenario 'log in as admin; redirect to another user profile page', js: true do
      visit user_path(user)
      login admin_user
      expect(current_path).to eq user_path(user)
      expect(page).to have_css 'div.alert-success'
      expect(page).not_to have_css 'div.alert-error'
    end

    scenario 'log in as non-admin; redirect to own user profile page', js: true do
      visit user_path(user)
      login user
      expect(current_path).to eq user_path(user)
      expect(page).to have_css 'div.alert-success'
      expect(page).not_to have_css 'div.alert-error'
    end

    scenario 'log in as non-admin; redirect to home page (another user profile page not permitted)', js: true do
      visit user_path(admin_user)
      login user
      expect(current_path).to eq root_path
      expect(page).to have_css 'div.alert-error'
      expect(page).not_to have_css 'div.alert-success'
    end
  end
end
