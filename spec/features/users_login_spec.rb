require 'rails_helper'

feature 'user log in' do
  context 'valid details' do
    let!(:user) { create :user }
    scenario 'should redirect to user page with success message', js: true do
      visit login_path
      expect(page).to have_selector :link, 'Log in'
      expect(page).not_to have_selector :link, 'Log out'
      fill_in 'session_email',    with: "#{user.email}"
      fill_in 'session_password', with: "#{user.password}"
      click_button 'Log in'
      expect(page).to have_css('div.alert-success')
      expect(page).not_to have_css('div.alert-error')
      expect(page).to have_selector :link, 'Log out'
      expect(page).not_to have_selector :link, 'Log in'
      expect(current_path).to eq "/users/1"
    end
  end

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
      expect(page).to have_selector :link, 'Log in'
      expect(page).not_to have_selector :link, 'Log out'
      visit root_path
      expect(page).not_to have_css('div.alert-error')
    end
  end
end