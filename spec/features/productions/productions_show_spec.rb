require 'rails_helper'

feature 'Production show page' do
  context 'no productions have been added' do
    scenario 'should display notification that no productions yet added', js: true do
      visit productions_path
      expect(page).to have_content 'No productions yet'
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
