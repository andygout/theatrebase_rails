require 'rails_helper'

feature 'productions' do
  context 'no productions have been added' do
    scenario 'should display a prompt to add a production', js: true do
      visit productions_path
      expect(page).to have_content 'No productions yet'
      expect(page).to have_link 'Add Production'
    end
  end

  context 'productions have been added' do
    before do
      Production.create(title: 'Hamlet')
    end

    scenario 'display productions', js: true do
      visit productions_path
      expect(page).to have_content('Hamlet')
      expect(page).not_to have_content('No productions yet')
    end
  end
end