require 'rails_helper'

feature 'User delete' do
  context 'logged in as admin' do
    let!(:admin_user) { create_logged_in_admin_user }
    let(:user) { create :user }
    let(:second_admin_user) { create :second_admin_user }
    scenario 'delete non-admin user; redirect to user index with success message', js: true do
      visit user_path(user)
      click_button 'Delete User'
      expect { click_button 'OK' }.to change { User.count }.by -1
      expect(User.exists? user.id).to be false
      expect(page).to have_css 'p.alert-success'
      expect(page).not_to have_css 'p.alert-error'
      expect(page).not_to have_link("#{user.name}", href: user_path(user))
      expect(current_path).to eq users_path
    end

    scenario 'delete own profile; redirect to home page with success message', js: true do
      visit user_path(admin_user)
      click_button 'Delete User'
      expect { click_button 'OK' }.to change { User.count }.by(-1)
                                        .and change { Admin.count }.by(-1)
      expect(User.exists? admin_user.id).to be false
      expect(Admin.exists? user_id: admin_user).to be false
      expect(page).to have_css 'p.alert-success'
      expect(page).not_to have_css 'p.alert-error'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(admin_user.id))
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq root_path
    end
  end

  context 'logged in as non-admin' do
    let!(:user) { create_logged_in_user }
    scenario 'delete own profile; redirect to home page with success message', js: true do
      visit user_path(user)
      click_button 'Delete User'
      expect { click_button 'OK' }.to change { User.count }.by -1
      expect(User.exists? user.id).to be false
      expect(Admin.exists? user_id: user).to be false
      expect(page).to have_css 'p.alert-success'
      expect(page).not_to have_css 'p.alert-error'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(user.id))
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq root_path
    end
  end
end