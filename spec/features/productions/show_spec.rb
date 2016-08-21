require 'rails_helper'

feature 'Production show' do
  context 'viewing production display page' do
    let!(:production) { create :production }

    scenario 'lets a user view a production display page', js: true do
      visit production_path(production.id, production.url)
      expect(page).to have_content production.title
    end
  end
end
