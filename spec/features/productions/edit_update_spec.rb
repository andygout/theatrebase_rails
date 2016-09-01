require 'rails_helper'

feature 'Production edit/update' do
  let(:user) { create :user }
  let(:production) { create :production }
  let(:production_attrs) { attributes_for :production }

  context 'editing productions' do
    scenario 'user must be logged in to see \'Edit Production\' button', js: true do
      visit production_path(production.id, production.url)
      expect(page).not_to have_button('Edit Production')
      log_in user
      visit production_path(production.id, production.url)
      expect(page).to have_button('Edit Production')
    end
  end

  context 'updating productions' do
    before(:each) do
      log_in user
      visit production_path(production.id, production.url)
      click_button 'Edit Production'
    end

    scenario 'with valid details: redirects to updated production page with success message', js: true do
      fill_in 'production_title', with: production_attrs[:title]
      click_button 'Update Production'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_content production_attrs[:title]
      expect(page).not_to have_content production.title
      production.reload
      expect(page).to have_current_path production_path(production.id, production.url)
    end

    scenario 'with invalid details: re-renders edit form with error messages (original URL persisted for routing on second failed attempt)', js: true do
      fill_in 'production_title', with: ' '
      click_button 'Update Production'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content production.title
      production.reload
      expect(page).to have_current_path production_path(production.id, production.url)
      fill_in 'production_title', with: ' '
      click_button 'Update Production'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content production.title
    end
  end
end
