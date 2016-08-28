require 'rails_helper'

feature 'Theatre edit/update' do
  context 'editing theatres' do
    let(:user) { create :user }
    let(:theatre) { create :theatre }

    scenario 'user must be logged in to see \'Edit Theatre\' button', js: true do
      visit theatre_path(theatre.url)
      expect(page).not_to have_button('Edit Theatre')
      log_in user
      visit theatre_path(theatre.url)
      expect(page).to have_button('Edit Theatre')
    end
  end

  context 'updating theatres with valid details' do
    let!(:user) { create_logged_in_user }
    let(:theatre) { create :theatre }
    let(:theatre_attrs) { attributes_for :theatre }

    scenario 'redirects to updated theatre page with success message; existing creator association remains and updater association updated', js: true do
      visit theatre_path(theatre.url)
      click_button 'Edit Theatre'
      fill_in 'theatre_name', with: theatre_attrs[:name]
      click_button 'Update Theatre'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_content theatre_attrs[:name]
      expect(page).not_to have_content theatre.name
      theatre.reload
      expect(page).to have_current_path theatre_path(theatre.url)
    end
  end

  context 'updating theatres with invalid details' do
    let!(:user) { create_logged_in_user }
    let(:theatre) { create :theatre }

    scenario 'invalid name given; re-renders edit form with error message; existing creator and updater associations remain', js: true do
      visit theatre_path(theatre.url)
      click_button 'Edit Theatre'
      fill_in 'theatre_name', with: ' '
      click_button 'Update Theatre'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content theatre.name
      theatre.reload
      expect(page).to have_current_path theatre_path(theatre.url)
    end

    scenario 'invalid name given twice; re-renders edit form each time with error message (original URL persisted for routing)', js: true do
      visit theatre_path(theatre.url)
      click_button 'Edit Theatre'
      fill_in 'theatre_name', with: ' '
      click_button 'Update Theatre'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content theatre.name
      theatre.reload
      expect(page).to have_current_path theatre_path(theatre.url)
      fill_in 'theatre_name', with: ' '
      click_button 'Update Theatre'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content theatre.name
    end
  end
end
