require 'rails_helper'

feature 'Production delete' do
  context 'deleting productions' do
    let(:user) { create :user }
    let(:production) { create :production }

    scenario 'user must be logged in to see \'Delete Production\' button', js: true do
      visit production_path(production)
      expect(page).not_to have_button('Delete Production')
      log_in user
      visit production_path(production)
      expect(page).to have_button('Delete Production')
    end

    scenario 'removes a production when a user clicks its delete link', js: true do
      log_in user
      visit production_path(production)
      click_button 'Delete Production'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_content production.title, count: 2
      expect(page).to have_current_path productions_path
    end
  end
end
