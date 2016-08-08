require 'rails_helper'

feature 'Theatre show page' do
  context 'viewing theatres' do
    let!(:theatre) { create :theatre }

    scenario 'lets a user view a theatre', js: true do
      visit theatre_path(theatre)
      expect(page).to have_content theatre.name
      expect(page).to have_current_path theatre_path(theatre)
    end
  end
end
