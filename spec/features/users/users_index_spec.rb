require 'rails_helper'

ENTRIES_PER_PAGE = 30

feature 'User index page' do
  context 'logged in as super-admin user' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }

    scenario '30 < users exist: will paginate', js: true do
      create_list(:list_users, ENTRIES_PER_PAGE)
      visit users_path
      expect(page).to have_css '.pagination'
      User.paginate(page: 1).each do |user|
        expect(page).to have_link(user.name, href: user_path(user))
      end
    end

    scenario '30 >= users exist: will not paginate', js: true do
      create_list(:list_users, ENTRIES_PER_PAGE-1)
      visit users_path
      expect(page).not_to have_css '.pagination'
      User.all.each do |user|
        expect(page).to have_link(user.name, href: user_path(user))
      end
    end
  end

  context 'logged in as admin user' do
    let!(:admin_user) { create_logged_in_admin_user }

    scenario '30 < users exist: will paginate', js: true do
      create_list(:list_users, ENTRIES_PER_PAGE)
      visit users_path
      expect(page).to have_css '.pagination'
      User.paginate(page: 1).each do |user|
        expect(page).to have_link(user.name, href: user_path(user))
      end
    end

    scenario '30 >= users exist: will not paginate', js: true do
      create_list(:list_users, ENTRIES_PER_PAGE-1)
      visit users_path
      expect(page).not_to have_css '.pagination'
      User.all.each do |user|
        expect(page).to have_link(user.name, href: user_path(user))
      end
    end
  end

  context 'logged in as non-admin user' do
    let!(:user) { create_logged_in_user }

    scenario 'redirect to home page', js: true do
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
end
