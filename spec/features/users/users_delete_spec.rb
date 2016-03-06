require 'rails_helper'

feature 'User delete' do
  context 'attempt delete user' do
    let!(:admin_user) { create_logged_in_admin_user }
    let(:user) { create :user }

    scenario 'delete permitted user; redirect to user index with success message', js: true do
      visit user_path(user)
      click_button 'Delete User'
      expect { click_button 'OK' }.to change { User.count }.by -1
      expect(User.exists? user.id).to be false
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_link(user.name, href: user_path(user))
      expect(page).to have_current_path users_path
    end

    scenario 'delete permitted user (self); logged out; redirect to home page with success message', js: true do
      visit user_path(admin_user)
      click_button 'Delete User'
      expect { click_button 'OK' }.to change { User.count }.by(-1)
                                 .and change { Admin.count }.by(-1)
      expect(User.exists? admin_user.id).to be false
      expect(Admin.exists? user_id: admin_user).to be false
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile', href: user_path(admin_user))
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_current_path root_path
    end
  end

  context 'opting to not delete given profile' do
    let(:user) { create_logged_in_user }

    scenario 'profile not deleted; remain on user page', js: true do
      visit user_path(user)
      click_button 'Delete User'
      expect { click_button 'Cancel' }.to change { User.count }.by 0
      expect(User.exists? user.id).to be true
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_current_path user_path(user)
    end
  end
end
