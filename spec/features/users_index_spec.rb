require 'rails_helper'

ENTRIES_PER_PAGE = 30

feature 'Visiting user index page' do
  context '30 < users exist' do
    scenario 'should paginate', js: true do
      create_logged_in_user
      create_list(:list_user, ENTRIES_PER_PAGE)
      visit users_path
      expect(page).to have_css 'div.pagination'
      User.paginate(page: 1).each do |user|
        expect(page).to have_link("#{user.name}", href: user_path(user))
      end
    end
  end

  context '30 >= users exist' do
    scenario 'should not paginate', js: true do
      create_logged_in_user
      create_list(:list_user, ENTRIES_PER_PAGE-1)
      visit users_path
      expect(page).not_to have_css 'div.pagination'
    end
  end
end
