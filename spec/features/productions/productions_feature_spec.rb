require 'rails_helper'

feature 'Productions' do
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

  context 'creating productions with valid details' do
    let(:production) { attributes_for :production }
    scenario 'redirects to created production page with success message', js: true do
      visit productions_path
      click_link 'Add Production'
      fill_in 'production_title', with: "#{production[:title]}"
      expect { click_button 'Create Production' }.to change { Production.count }.by 1
      expect(page).to have_css 'div.alert-success'
      expect(page).not_to have_css 'div.alert-error'
      expect(page).not_to have_css 'li.field_with_errors'
      expect(page).to have_content 'Hamlet', count: 2
      expect(current_path).to eq "/productions/1"
    end
  end

  context 'creating productions with invalid details' do
    scenario 'invalid title given; re-renders add form with error message', js: true do
      visit productions_path
      click_link 'Add Production'
      fill_in 'production_title', with: ' '
      expect { click_button 'Create Production' }.to change { Production.count }.by 0
      expect(page).to have_css 'div.alert-error'
      expect(page).to have_css 'li.field_with_errors'
      expect(page).not_to have_css 'div.alert-success'
      expect(page).to have_content "New Production"
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

  context 'editing productions with valid details' do
    let(:production) { create :production }
    scenario 'redirects to updated production page with success message', js: true do
      visit "/productions/#{production.id}"
      click_link 'Edit Production'
      fill_in 'production_title', with: 'Macbeth'
      click_button 'Update Production'
      expect(page).to have_css 'div.alert-success'
      expect(page).not_to have_css 'div.alert-error'
      expect(page).not_to have_css 'li.field_with_errors'
      expect(page).to have_content 'Macbeth', count: 2
      expect(page).not_to have_content "#{production.title}"
      expect(current_path).to eq "/productions/#{production.id}"
    end
  end

  context 'editing productions with invalid details' do
    let(:production) { create :production }
    scenario 'invalid title given; re-renders edit form with error message', js: true do
      visit "/productions/#{production.id}"
      click_link 'Edit Production'
      fill_in 'production_title', with: ' '
      click_button 'Update Production'
      expect(page).to have_css 'div.alert-error'
      expect(page).to have_css 'li.field_with_errors'
      expect(page).not_to have_css 'div.alert-success'
      expect(page).to have_content "#{production.title}"
      expect(current_path).to eq "/productions/#{production.id}"
    end
  end

  context 'deleting productions' do
    let(:production) { create :production }
    scenario 'removes a production when a user clicks its delete link', js: true do
      visit "/productions/#{production.id}"
      click_link 'Delete Production'
      expect(page).to have_css 'div.alert-success'
      expect(page).not_to have_css 'div.alert-error'
      expect(page).not_to have_content "#{production.title}", count: 2
      expect(current_path).to eq productions_path
    end
  end
end