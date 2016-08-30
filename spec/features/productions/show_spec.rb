require 'rails_helper'

feature 'Production show' do
  let!(:production) { create :production }

  context 'viewing production display page' do
    scenario 'lets a user view a production display page', js: true do
      visit production_path(production.id, production.url)
      expect(page).to have_content production.title
    end
  end
end
