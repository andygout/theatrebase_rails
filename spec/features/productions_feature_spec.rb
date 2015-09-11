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

  context 'creating productions' do
    scenario 'prompts user to complete form, then displays new production', js: true do
      visit productions_path
      click_link 'Add Production'
      fill_in 'production_title', with: 'Hamlet'
      click_button 'Create Production'
      expect(page).to have_content 'Hamlet'
      expect(current_path).to eq productions_path
    end
  end
end