require 'rails_helper'

ENTRIES_PER_PAGE = 30

feature 'User index page' do
  context 'logged in as super-admin' do
    scenario '30 < users exist: will paginate', js: true do
      create_logged_in_super_admin_user
      create_list(:list_users, ENTRIES_PER_PAGE)
      visit users_path
      expect(page).to have_css '.pagination'
      User.paginate(page: 1).each do |user|
        expect(page).to have_link(user.name, href: user_path(user))
      end
    end

    scenario '30 >= users exist: will not paginate', js: true do
      create_logged_in_super_admin_user
      create_list(:list_users, ENTRIES_PER_PAGE-1)
      visit users_path
      expect(page).not_to have_css '.pagination'
      User.all.each do |user|
        expect(page).to have_link(user.name, href: user_path(user))
      end
    end
  end

  context 'logged in as admin' do
    scenario '30 < users exist: will paginate', js: true do
      create_logged_in_admin_user
      create_list(:list_users, ENTRIES_PER_PAGE)
      visit users_path
      expect(page).to have_css '.pagination'
      User.paginate(page: 1).each do |user|
        expect(page).to have_link(user.name, href: user_path(user))
      end
    end

    scenario '30 >= users exist: will not paginate', js: true do
      create_logged_in_admin_user
      create_list(:list_users, ENTRIES_PER_PAGE-1)
      visit users_path
      expect(page).not_to have_css '.pagination'
      User.all.each do |user|
        expect(page).to have_link(user.name, href: user_path(user))
      end
    end
  end

  context 'logged in as non-admin' do
    scenario 'redirect to home page', js: true do
      create_logged_in_user
      visit users_path
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'not logged in' do
    scenario 'redirect to log in page', js: true do
      visit users_path
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq log_in_path
    end
  end

  context 'friendly forwarding: logging in redirects to user index page (if permitted)' do
    before(:each) do
      visit users_path
    end

    let(:super_admin_user) { create :super_admin_user }
    let(:admin_user) { create :admin_user }
    let(:user) { create :user }

    scenario 'log in as super-admin; redirect to user index page', js: true do
      log_in super_admin_user
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(current_path).to eq users_path
    end

    scenario 'log in as admin; redirect to user index page', js: true do
      log_in admin_user
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(current_path).to eq users_path
    end

    scenario 'log in as non-admin; redirect to home page (user index not permitted)', js: true do
      log_in user
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq root_path
    end
  end
end
