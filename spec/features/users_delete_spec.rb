require 'rails_helper'

feature 'User delete' do
  context 'logged in as admin' do
    let!(:admin_user) { create_logged_in_admin_user }
    let(:second_user) { create :second_user }
    scenario 'should delete other user; redirect to user index with success message', js: true do
      visit user_path(second_user)
      expect { click_link 'Delete User' }.to change { User.count }.by -1
      expect(page).to have_css 'div.alert-success'
      expect(page).not_to have_css 'div.alert-error'
      expect(page).not_to have_css 'li.field_with_errors'
      expect(page).not_to have_link("#{second_user.name}", href: user_path(second_user))
      expect(current_path).to eq users_path
    end

    scenario 'delete link not available for own profile', js: true do
      visit user_path(admin_user)
      expect(page).not_to have_link("#{admin_user.name}", href: user_path(admin_user))
      expect(current_path).to eq user_path(admin_user)
    end
  end
end