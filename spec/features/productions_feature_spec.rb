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
    let!(:production) { create :production }
    scenario 'display productions', js: true do
      visit productions_path
      expect(page).to have_content "#{production.title}"
      expect(page).not_to have_content 'No productions yet'
    end
  end

  context 'creating productions' do
    scenario 'prompts user to complete form, then displays new production', js: true do
      visit productions_path
      click_link 'Add Production'
      fill_in 'production_title', with: 'Hamlet'
      click_button 'Create Production'
      expect(page).to have_content 'Production created successfully: Hamlet'
      expect(page).to have_content 'Hamlet', count: 2
      expect(current_path).to eq productions_path
    end
  end

  context 'viewing productions' do
    let!(:production) { create :production }
    scenario 'lets a user view a production', js: true do
      visit productions_path
      click_link "#{production.title}"
      expect(page).to have_content "#{production.title}"
      expect(current_path).to eq production_path(production)
    end
  end

  context 'editing productions' do
    let!(:production) { create :production }
    scenario 'let a user edit a production', js: true do
      visit "/productions/#{production.id}"
      click_link 'Edit Production'
      fill_in 'production_title', with: 'Macbeth'
      click_button 'Update Production'
      expect(page).to have_content 'Production updated successfully: Macbeth'
      expect(page).to have_content 'Macbeth', count: 2
      expect(page).not_to have_content "#{production.title}"
      expect(current_path).to eq "/productions/#{production.id}"
    end
  end

  context 'deleting productions' do
    let!(:production) { create :production }
    scenario 'removes a production when a user clicks its delete link', js: true do
      visit "/productions/#{production.id}"
      click_link 'Delete Production'
      expect(page).to have_content "Production deleted successfully: #{production.title}"
      expect(page).not_to have_content "#{production.title}", count: 2
    end
  end
end