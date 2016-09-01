require 'rails_helper'

feature 'Production routing' do
  let!(:production) { create :production }

  context 'displaying 404 error pages when incorrect params given' do
    scenario 'production page only displayed if correct id and URL params are given', js: true do
      visit production_path(production.id, production.url)
      expect(page).to have_content production.title
      expect(page).to have_current_path production_path(production.id, production.url)
    end

    scenario 'error page if incorrect id param is given', js: true do
      visit production_path(production.id + 1, production.url)
      expect(page).to have_content '404 Error'
      expect(page).to have_current_path production_path(production.id + 1, production.url)
    end

    scenario 'error page if incorrect URL param is given', js: true do
      visit production_path(production.id, "#{production.url}foobar")
      expect(page).to have_content '404 Error'
      expect(page).to have_current_path production_path(production.id, "#{production.url}foobar")
    end

    scenario 'error page if incorrect id and URL params are given', js: true do
      visit production_path(production.id + 1, "#{production.url}foobar")
      expect(page).to have_content '404 Error'
      expect(page).to have_current_path production_path(production.id + 1, "#{production.url}foobar")
    end
  end
end
