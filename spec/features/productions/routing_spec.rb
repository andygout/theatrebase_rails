require 'rails_helper'

feature 'Production routing' do
  context 'displaying 404 error pages when incorrect params given' do
    let!(:production) { create :production }

    scenario 'production page only displayed if correct id and URL params are given', js: true do
      visit production_path(production.id, production.url)
      expect(page).to have_content production.title
      expect(page).to have_current_path production_path(production.id, production.url)
    end

    scenario 'error page if incorrect id param is given', js: true do
      visit production_path(2, production.url)
      expect(page).to have_content '404 Error'
      expect(page).to have_current_path production_path(2, production.url)
    end

    scenario 'error page if incorrect URL param is given', js: true do
      visit production_path(production.id, 'othello')
      expect(page).to have_content '404 Error'
      expect(page).to have_current_path production_path(production.id, 'othello')
    end

    scenario 'error page if incorrect id and URL params are given', js: true do
      visit production_path(2, 'othello')
      expect(page).to have_content '404 Error'
      expect(page).to have_current_path production_path(2, 'othello')
    end
  end
end
