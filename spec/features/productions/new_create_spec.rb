require 'rails_helper'

feature 'Production new/create' do
  context 'new productions' do
    let(:user) { create :user }

    scenario 'user must be logged in to see \'New production\' link', js: true do
      visit root_path
      expect(page).not_to have_link('New production', href: new_production_path)
      log_in user
      expect(page).to have_link('New production', href: new_production_path)
    end

    scenario 'click on \'New production\' link; display new production page', js: true do
      visit root_path
      log_in user
      click_link 'New production'
      expect(page).to have_current_path new_production_path
    end
  end

  context 'creating productions with valid details' do
    let!(:user) { create_logged_in_user }
    let(:production_attrs) { attributes_for :production }
    let(:theatre_attrs) { attributes_for :theatre }

    scenario 'redirect to created production page with success message', js: true do
      visit productions_path
      click_link 'New production'
      fill_in 'production_title', with: production_attrs[:title]
      fill_in 'production_first_date', with: production_attrs[:first_date]
      fill_in 'production_last_date', with: production_attrs[:last_date]
      fill_in 'production_theatre_attributes_name', with: theatre_attrs[:name]
      expect { click_button 'Create Production' }
        .to change { Production.count }.by(1)
        .and change { Theatre.count }.by(1)
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_content production_attrs[:title]
      production = Production.last
      expect(page).to have_current_path production_path(production.id, production.url)
    end
  end

  context 'creating productions with invalid details' do
    let!(:user) { create_logged_in_user }
    let(:production_attrs) { attributes_for :production }
    let(:theatre_attrs) { attributes_for :theatre }

    scenario 'invalid title given; re-renders form with error message', js: true do
      visit productions_path
      click_link 'New production'
      fill_in 'production_title', with: ' '
      fill_in 'production_first_date', with: production_attrs[:first_date]
      fill_in 'production_last_date', with: production_attrs[:last_date]
      fill_in 'production_theatre_attributes_name', with: theatre_attrs[:name]
      expect { click_button 'Create Production' }
        .to change { Production.count }.by(0)
        .and change { Theatre.count }.by(0)
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content 'New production'
      expect(page).to have_current_path productions_path
    end
  end
end
