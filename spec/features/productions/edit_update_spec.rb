require 'rails_helper'

feature 'Production edit/update' do
  context 'editing productions' do
    let(:user) { create :user }
    let(:production) { create :production }

    scenario 'user must be logged in to see \'Edit Production\' button', js: true do
      visit production_path(production.id, production.url)
      expect(page).not_to have_button('Edit Production')
      log_in user
      visit production_path(production.id, production.url)
      expect(page).to have_button('Edit Production')
    end
  end

  context 'updating productions with valid details' do
    let!(:user) { create_logged_in_user }
    let(:production) { create :production }

    scenario 'redirects to updated production page with success message', js: true do
      visit production_path(production.id, production.url)
      click_button 'Edit Production'
      fill_in 'production_title', with: 'Macbeth'
      click_button 'Update Production'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_content 'Macbeth'
      expect(page).not_to have_content production.title
      production.reload
      expect(page).to have_current_path production_path(production.id, production.url)
    end
  end

  context 'updating productions with invalid details' do
    let!(:user) { create_logged_in_user }
    let(:production) { create :production }

    scenario 'invalid title given; re-renders edit form with error message', js: true do
      visit production_path(production.id, production.url)
      click_button 'Edit Production'
      fill_in 'production_title', with: ' '
      click_button 'Update Production'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content production.title
      production.reload
      expect(page).to have_current_path production_path(production.id, production.url)
    end

    scenario 'invalid title given twice; re-renders edit form each time with error message (original URL persisted for routing)', js: true do
      visit production_path(production.id, production.url)
      click_button 'Edit Production'
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
