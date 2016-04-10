require 'rails_helper'

ENTRIES_PER_PAGE = 30

feature 'User index page' do
  context 'view user index page as permitted user' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }

    scenario '30 < users exist; will paginate', js: true do
      create_list(:list_users, ENTRIES_PER_PAGE)
      visit users_path
      expect(page).to have_css '.pagination'
    end

    scenario '30 >= users exist; will not paginate', js: true do
      create_list(:list_users, ENTRIES_PER_PAGE - 1)
      visit users_path
      expect(page).not_to have_css '.pagination'
    end
  end

  context 'view user index page as super-admin user' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }
    let!(:second_super_admin_user) { create :second_super_admin_user }
    let!(:admin_user) { create :admin_user }
    let!(:user) { create :user }

    scenario 'only self, admin and non-admin users will be included', js: true do
      visit users_path
      expect(page).to have_link(super_admin_user.name, href: user_path(super_admin_user))
      expect(page).not_to have_link(second_super_admin_user.name, href: user_path(second_super_admin_user))
      expect(page).to have_link(admin_user.name, href: user_path(admin_user))
      expect(page).to have_link(user.name, href: user_path(user))
    end
  end

  context 'view user index page as admin user: only viewable users will be included' do
    let!(:admin_user) { create_logged_in_admin_user }
    let!(:super_admin_user) { create :super_admin_user }
    let!(:second_admin_user) { create :second_admin_user }
    let!(:user) { create :user }

    scenario 'only self and non-admin users will be included', js: true do
      visit users_path
      expect(page).to have_link(admin_user.name, href: user_path(admin_user))
      expect(page).not_to have_link(super_admin_user.name, href: user_path(super_admin_user))
      expect(page).not_to have_link(second_admin_user.name, href: user_path(second_admin_user))
      expect(page).to have_link(user.name, href: user_path(user))
    end
  end
end
