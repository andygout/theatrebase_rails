require 'rails_helper'

ENTRIES_PER_PAGE = 30

feature 'User index page' do
  context 'attempt view user index page as permitted user' do
    let!(:super_admin_user) { create_logged_in_super_admin_user }

    scenario '30 < users exist; will paginate', js: true do
      create_list(:list_users, ENTRIES_PER_PAGE)
      visit users_path
      expect(page).to have_css '.pagination'
      User.paginate(page: 1).each do |user|
        expect(page).to have_link(user.name, href: user_path(user))
      end
    end

    scenario '30 >= users exist; will not paginate', js: true do
      create_list(:list_users, ENTRIES_PER_PAGE-1)
      visit users_path
      expect(page).not_to have_css '.pagination'
      User.all.each do |user|
        expect(page).to have_link(user.name, href: user_path(user))
      end
    end
  end
end
