require 'rails_helper'

feature 'Production index' do
  context 'no productions have been added' do
    scenario 'should display notification that no productions yet added', js: true do
      visit productions_path
      expect(page).to have_content 'No productions yet'
    end
  end

  context 'productions have been added' do
    let!(:production) { create :production }

    scenario 'will display existing productions', js: true do
      visit productions_path
      expect(page).to have_content production.title
      expect(page).not_to have_content 'No productions yet'
    end

    scenario 'lets a user click through to a production display page', js: true do
      visit productions_path
      click_link production.title
      expect(page).to have_content production.title
      expect(page).to have_current_path production_path(production.id, production.url)
    end
  end
end
