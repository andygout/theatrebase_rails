require 'rails_helper'

feature 'Production edit/update' do
  context 'editing productions' do
    let(:user) { create :user }
    let(:production) { create :production }

    scenario 'user must be logged in to see \'Edit Production\' button', js: true do
      visit production_path(production)
      expect(page).not_to have_button('Edit Production')
      log_in user
      visit production_path(production)
      expect(page).to have_button('Edit Production')
    end
  end

  context 'updating productions with valid details' do
    let!(:user) { create_logged_in_user }
    let(:production) { create :production }
    let(:second_user) { production.creator }

    scenario 'redirects to updated production page with success message; existing creator association remains and updater association updated', js: true do
      visit production_path(production)
      click_button 'Edit Production'
      fill_in 'production_title', with: 'Macbeth'
      click_button 'Update Production'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_content 'Macbeth', count: 2
      expect(page).not_to have_content production.title
      expect(current_path).to eq production_path(production)
      expect(production.reload.creator).to eq(second_user)
      expect(production.updater).to eq(user)
      expect(second_user.created_productions).to include(production)
      expect(second_user.updated_productions).not_to include(production)
      expect(user.created_productions).not_to include(production)
      expect(user.updated_productions).to include(production)
    end
  end

  context 'updating productions with invalid details' do
    let!(:user) { create_logged_in_user }
    let(:production) { create :production }
    let(:second_user) { production.creator }

    scenario 'invalid title given; re-renders edit form with error message; existing creator and updater associations remain', js: true do
      visit production_path(production)
      click_button 'Edit Production'
      fill_in 'production_title', with: ' '
      click_button 'Update Production'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content production.title
      expect(current_path).to eq production_path(production)
      expect(production.reload.creator).to eq(second_user)
      expect(production.updater).to eq(second_user)
      expect(second_user.created_productions).to include(production)
      expect(second_user.updated_productions).to include(production)
      expect(user.created_productions).not_to include(production)
      expect(user.updated_productions).not_to include(production)
    end
  end
end
