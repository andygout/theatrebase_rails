require 'rails_helper'

feature 'Production new/create' do
  context 'adding productions' do
    let(:user) { create :user }

    scenario 'user must be logged in to see \'Add production\' link', js: true do
      visit root_path
      expect(page).not_to have_link('Add production', href: new_production_path)
      log_in user
      expect(page).to have_link('Add production', href: new_production_path)
    end
  end

  context 'creating productions with valid details' do
    let!(:user) { create_logged_in_user }
    let(:production) { attributes_for :production }

    scenario 'redirect to created production page with success message; creator and updater associations created', js: true do
      visit productions_path
      click_link 'Add production'
      fill_in 'production_title', with: production[:title]
      fill_in 'production_first_date', with: production[:first_date]
      fill_in 'production_last_date', with: production[:last_date]
      expect { click_button 'Create Production' }.to change { Production.count }.by 1
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_content 'Hamlet', count: 2
      @production = Production.last
      expect(page).to have_current_path production_path(@production)
      expect(@production.creator).to eq user
      expect(@production.updater).to eq user
      expect(user.created_productions).to include @production
      expect(user.updated_productions).to include @production
    end
  end

  context 'creating productions with invalid details' do
    let!(:user) { create_logged_in_user }
    let(:production) { attributes_for :production }

    scenario 'invalid title given; re-renders form with error message', js: true do
      visit productions_path
      click_link 'Add production'
      fill_in 'production_title', with: ' '
      fill_in 'production_first_date', with: production[:first_date]
      fill_in 'production_last_date', with: production[:last_date]
      expect { click_button 'Create Production' }.to change { Production.count }.by 0
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content 'New production'
      expect(page).to have_current_path productions_path
    end
  end
end
