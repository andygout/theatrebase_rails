require 'rails_helper'

feature 'Productions' do
  context 'no productions have been added' do
    scenario 'should display notification that no productions yet added', js: true do
      visit productions_path
      expect(page).to have_content 'No productions yet'
    end
  end

  context 'adding productions' do
    let(:user) { create :user }

    scenario 'user must be logged in to see \'Add Production\' link' do
      visit root_path
      expect(page).not_to have_link('Add Production', href: new_production_path)
      log_in user
      expect(page).to have_link('Add Production', href: new_production_path)
    end
  end

  context 'creating productions with valid details' do
    let!(:user) { create_logged_in_user }
    let(:production) { attributes_for :production }

    scenario 'redirects to created production page with success message', js: true do
      visit productions_path
      click_link 'Add Production'
      fill_in 'production_title', with: production[:title]
      expect { click_button 'Create Production' }.to change { Production.count }.by 1
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_content 'Hamlet', count: 2
      expect(current_path).to eq production_path(Production.last)
    end
  end

  context 'creating productions with invalid details' do
    let!(:user) { create_logged_in_user }

    scenario 'invalid title given; re-renders add form with error message', js: true do
      visit productions_path
      click_link 'Add Production'
      fill_in 'production_title', with: ' '
      expect { click_button 'Create Production' }.to change { Production.count }.by 0
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content 'New Production'
      expect(current_path).to eq productions_path
    end
  end

  context 'editing productions' do
    let(:user) { create :user }
    let(:production) { create :production }

    scenario 'user must be logged in to see \'Edit Production\' button' do
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

    scenario 'redirects to updated production page with success message', js: true do
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
    end
  end

  context 'updating productions with invalid details' do
    let!(:user) { create_logged_in_user }
    let(:production) { create :production }

    scenario 'invalid title given; re-renders edit form with error message', js: true do
      visit production_path(production)
      click_button 'Edit Production'
      fill_in 'production_title', with: ' '
      click_button 'Update Production'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content production.title
      expect(current_path).to eq production_path(production)
    end
  end

  context 'deleting productions' do
    let(:user) { create :user }
    let(:production) { create :production }

    scenario 'user must be logged in to see \'Delete Production\' button' do
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
      expect(current_path).to eq productions_path
    end
  end

  context 'viewing productions' do
    let!(:production) { create :production }

    scenario 'lets a user view a production', js: true do
      visit productions_path
      click_link production.title
      expect(page).to have_content production.title
      expect(current_path).to eq production_path(production)
    end
  end

  context 'visiting production index' do
    let!(:production) { create :production }

    scenario 'will display existing productions', js: true do
      visit productions_path
      expect(page).to have_content production.title
      expect(page).not_to have_content 'No productions yet'
    end
  end
end
