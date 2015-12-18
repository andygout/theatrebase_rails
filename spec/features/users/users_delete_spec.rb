require 'rails_helper'

feature 'User delete' do
  context 'logged in as admin' do
    let!(:admin_user) { create_logged_in_admin_user }
    let(:user) { create :user }
    let(:second_admin_user) { create :second_admin_user }

    scenario 'opt to not delete non-admin user; remain on user page', js: true do
      visit user_path(user)
      click_button 'Delete User'
      expect { click_button 'Cancel' }.to change { User.count }.by 0
      expect(User.exists? user.id).to be true
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq user_path(user)
    end

    scenario 'opt to not delete own profile; remain on user page', js: true do
      visit user_path(admin_user)
      click_button 'Delete User'
      expect { click_button 'Cancel' }.to change { User.count }.by 0
      expect(User.exists? admin_user.id).to be true
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq user_path(admin_user)
    end

    scenario 'delete non-admin user; redirect to user index with success message', js: true do
      visit user_path(user)
      click_button 'Delete User'
      expect { click_button 'OK' }.to change { User.count }.by -1
      expect(User.exists? user.id).to be false
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_link(user.name, href: user_path(user))
      expect(current_path).to eq users_path
    end

    scenario 'delete own profile; redirect to home page with success message', js: true do
      visit user_path(admin_user)
      click_button 'Delete User'
      expect { click_button 'OK' }.to change { User.count }.by(-1)
                                 .and change { Admin.count }.by(-1)
      expect(User.exists? admin_user.id).to be false
      expect(Admin.exists? user_id: admin_user).to be false
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(admin_user))
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq root_path
    end
  end

  context 'logged in as non-admin' do
    let!(:user) { create_logged_in_user }

    before(:each) do
      visit user_path(user)
      click_button 'Delete User'
    end

    scenario 'opt to not delete own profile; remain on user page', js: true do
      expect { click_button 'Cancel' }.to change { User.count }.by 0
      expect(User.exists? user.id).to be true
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq user_path(user)
    end

    scenario 'delete own profile; redirect to home page with success message', js: true do
      expect { click_button 'OK' }.to change { User.count }.by -1
      expect(User.exists? user.id).to be false
      expect(Admin.exists? user_id: user).to be false
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(user))
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq root_path
    end
  end
end
