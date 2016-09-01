require 'rails_helper'

feature 'Theatre edit/update' do
  let(:user) { create :user }
  let(:theatre) { create :theatre }
  let(:theatre_attrs) { attributes_for :theatre }

  context 'editing theatres' do
    scenario 'user must be logged in to see \'Edit Theatre\' button', js: true do
      visit theatre_path(theatre.url)
      expect(page).not_to have_button('Edit Theatre')
      log_in user
      visit theatre_path(theatre.url)
      expect(page).to have_button('Edit Theatre')
    end
  end

  context 'updating theatres' do
    before(:each) do
      log_in user
      visit theatre_path(theatre.url)
      click_button 'Edit Theatre'
    end

    scenario 'with valid details: redirects to updated theatre page with success message', js: true do
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

    scenario 'with invalid details: re-renders edit form with error messages (original URL persisted for routing on second failed attempt)', js: true do
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
