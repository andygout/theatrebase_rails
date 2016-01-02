require 'rails_helper'

feature 'User delete' do
  context 'logged in as super-admin' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let(:second_super_admin_user) { create :second_super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }

    scenario 'attempt delete own profile; prevented by absent delete button', js: true do
      visit user_path(super_admin_user)
      expect(page).not_to have_button('Delete User')
    end

    scenario 'attempt delete other super-admin user; prevented by absent delete button', js: true do
      visit user_path(second_super_admin_user)
      expect(page).not_to have_button('Delete User')
    end

    scenario 'delete admin user; redirect to user index with success message', js: true do
      visit user_path(admin_user)
      click_button 'Delete User'
      expect { click_button 'OK' }.to change { User.count }.by(-1)
                                 .and change { Admin.count }.by(-1)
      expect(User.exists? admin_user.id).to be false
      expect(Admin.exists? user_id: admin_user.id).to be false
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_link(user.name, href: user_path(admin_user))
      expect(current_path).to eq users_path
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
  end

  context 'logged in as admin' do
    let!(:admin_user) { create_logged_in_admin_user }
    let(:super_admin_user) { create :super_admin_user }
    let(:second_admin_user) { create :second_admin_user }
    let(:user) { create :user }

    scenario 'attempt delete super-admin user; prevented by absent delete button', js: true do
      visit user_path(super_admin_user)
      expect(page).not_to have_button('Delete User')
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
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile', href: user_path(admin_user))
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(current_path).to eq root_path
    end

    scenario 'attempt delete other admin user; prevented by absent delete button', js: true do
      visit user_path(second_admin_user)
      expect(page).not_to have_button('Delete User')
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
  end

  context 'logged in as non-admin' do
    let!(:user) { create_logged_in_user }

    scenario 'delete own profile; redirect to home page with success message', js: true do
      visit user_path(user)
      click_button 'Delete User'
      expect { click_button 'OK' }.to change { User.count }.by -1
      expect(User.exists? user.id).to be false
      expect(Admin.exists? user_id: user).to be false
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile', href: user_path(user))
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(current_path).to eq root_path
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
      expect(current_path).to eq user_path(user)
    end
  end
end
