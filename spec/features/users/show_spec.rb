require 'rails_helper'

feature 'User show' do
  context 'attempt view user profile' do
    let!(:user) { create_logged_in_user }
    let(:second_user) { create :second_user }

    scenario 'viewing own non-admin user profile: show own non-admin user profile page', js: true do
      visit user_path(user)
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_button('Edit User')
      expect(page).not_to have_button('Edit Admin Status')
      expect(page).not_to have_button('Edit Suspension Status')
      expect(page).to have_button('Delete User')
      expect(page).to have_current_path user_path(user)
    end

    scenario 'attempting to view another non-admin user profile: redirect to home page', js: true do
      visit user_path(second_user)
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end
  end
end
