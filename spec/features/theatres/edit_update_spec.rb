require 'rails_helper'

feature 'Theatre edit/update' do
  context 'editing theatres' do
    let(:user) { create :user }
    let(:theatre) { create :theatre }

    scenario 'user must be logged in to see \'Edit Theatre\' button', js: true do
      visit theatre_path(theatre)
      expect(page).not_to have_button('Edit Theatre')
      log_in user
      visit theatre_path(theatre)
      expect(page).to have_button('Edit Theatre')
    end
  end

  context 'updating theatres with valid details' do
    let!(:user) { create_logged_in_user }
    let(:theatre) { create :theatre }
    let(:second_user) { theatre.creator }

    scenario 'redirects to updated theatre page with success message; existing creator association remains and updater association updated', js: true do
      visit theatre_path(theatre)
      click_button 'Edit Theatre'
      fill_in 'theatre_name', with: 'Almeida Theatre'
      click_button 'Update Theatre'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_content 'Almeida Theatre'
      expect(page).not_to have_content theatre.name
      theatre.reload
      expect(page).to have_current_path theatre_path(theatre)
      expect(theatre.creator).to eq second_user
      expect(theatre.updater).to eq user
      expect(second_user.created_theatres).to include theatre
      expect(second_user.updated_theatres).not_to include theatre
      expect(user.created_theatres).not_to include theatre
      expect(user.updated_theatres).to include theatre
    end
  end

  context 'updating theatres with invalid details' do
    let!(:user) { create_logged_in_user }
    let(:theatre) { create :theatre }
    let(:second_user) { theatre.creator }

    scenario 'invalid name given; re-renders edit form with error message; existing creator and updater associations remain', js: true do
      visit theatre_path(theatre)
      click_button 'Edit Theatre'
      fill_in 'theatre_name', with: ' '
      click_button 'Update Theatre'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content theatre.name
      theatre.reload
      expect(page).to have_current_path theatre_path(theatre)
      expect(theatre.creator).to eq second_user
      expect(theatre.updater).to eq second_user
      expect(second_user.created_theatres).to include theatre
      expect(second_user.updated_theatres).to include theatre
      expect(user.created_theatres).not_to include theatre
      expect(user.updated_theatres).not_to include theatre
    end

    scenario 'invalid name given twice; re-renders edit form each time with error message (original URL persisted for routing)', js: true do
      visit theatre_path(theatre)
      click_button 'Edit Theatre'
      fill_in 'theatre_name', with: ' '
      click_button 'Update Theatre'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content theatre.name
      theatre.reload
      expect(page).to have_current_path theatre_path(theatre)
      fill_in 'theatre_name', with: ' '
      click_button 'Update Theatre'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content theatre.name
    end
  end
end
