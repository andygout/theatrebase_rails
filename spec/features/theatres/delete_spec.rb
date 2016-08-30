require 'rails_helper'

feature 'Theatre delete' do
  let(:user) { create :user }
  let(:theatre) { create :theatre }

  context 'deleting theatres' do

    scenario 'user must be logged in to see \'Delete Theatre\' button', js: true do
      visit theatre_path(theatre.url)
      expect(page).not_to have_button('Delete Theatre')
      log_in user
      visit theatre_path(theatre.url)
      expect(page).to have_button('Delete Theatre')
    end

    scenario 'removes a theatre when a user clicks its delete link', js: true do
      log_in user
      visit theatre_path(theatre.url)
      click_button 'Delete Theatre'
      expect { click_button 'OK' }.to change { Theatre.count }.by -1
      expect(Theatre.exists? theatre.id).to be false
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end
  end
end
