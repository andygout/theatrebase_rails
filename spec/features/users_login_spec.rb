require 'rails_helper'

feature 'user log in' do
  context 'invalid details' do
    let(:invalid_user) { attributes_for :invalid_user }
    scenario 'should re-render form with error message', js: true do
      visit login_path
      fill_in 'session_email',    with: "#{invalid_user[:email]}"
      fill_in 'session_password', with: "#{invalid_user[:password]}"
      click_button 'Log in'
      expect(page).to have_css('div.alert-error')
      expect(page).not_to have_css('div.alert-success')
      expect(current_path).to eq login_path
      visit root_path
      expect(page).not_to have_css('div.alert-error')
    end
  end
end