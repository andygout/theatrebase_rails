require 'rails_helper'

feature 'User password reset' do
  context 'submitting request for password reset email' do
    let(:user) { create :user }

    scenario 'redirect to home page with success message; password reset email sent', js: true do
      visit login_path
      click_link 'Reset password'
      fill_in 'password_reset_email', with: user.email
      expect { click_button 'Submit' }.to change { ActionMailer::Base.deliveries.count }.by 1
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(current_path).to eq root_path
    end
  end

  context 'clicking password reset link' do
    let(:user) { create :user }

    before(:each) do
      request_password_reset user
      @msg = ActionMailer::Base.deliveries.last.to_s
      @password_reset_token = acquire_token @msg
    end

    scenario 'not valid if invalid token given', js: true do
      user_email = acquire_email_address @msg
      visit edit_password_reset_path('invalid-token', email: user_email)
      expect(current_path).to eq root_path
    end

    scenario 'not valid if invalid email given', js: true do
      visit edit_password_reset_path(@password_reset_token, email: 'incorrect-email')
      expect(current_path).to eq root_path
    end

    scenario 'valid if valid token and correct email given', js: true do
      user = click_resource_link @msg, 'password_reset'
      expect(find('#email', :visible => false).value).to eq user.email
      expect(current_path).to eq edit_password_reset_path(@password_reset_token)
    end

    scenario 'redirects to home page if user not activated', js: true do
      user.update_attribute(:activated, false)
      click_resource_link @msg, 'password_reset'
      expect(current_path).to eq root_path
    end

    scenario 'redirects to link request page if token has expired', js: true do
      user.update_attribute(:reset_sent_at, 3.hours.ago)
      click_resource_link @msg, 'password_reset'
      expect(page).to have_css '.alert-error'
      expect(current_path).to eq new_password_reset_path
    end
  end

  context 'submitting password reset form' do
    let(:user) { create :user }

    before(:each) do
      request_password_reset user
      @msg = ActionMailer::Base.deliveries.last.to_s
      @password_reset_token = acquire_token @msg
      @user = click_resource_link @msg, 'password_reset'
    end

    scenario 'password cannot be reset without entering new password & confirmation', js: true do
      fill_in 'user_password',              with: ''
      fill_in 'user_password_confirmation', with: ''
      click_button 'Reset Password'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq password_reset_path(@password_reset_token)
    end

    scenario 'password cannot be reset by entering password and confirmation that are too short', js: true do
      fill_in 'user_password',              with: 'foo'
      fill_in 'user_password_confirmation', with: 'foo'
      click_button 'Reset Password'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq password_reset_path(@password_reset_token)
    end

    scenario 'password cannot be reset by entering non-matching password and confirmation', js: true do
      fill_in 'user_password',              with: 'foobar'
      fill_in 'user_password_confirmation', with: 'barfoo'
      click_button 'Reset Password'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq password_reset_path(@password_reset_token)
    end

    scenario 'password is reset by entering valid password and confirmation', js: true do
      fill_in 'user_password',              with: 'new-password'
      fill_in 'user_password_confirmation', with: 'new-password'
      click_button 'Reset Password'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(current_path).to eq user_path(@user)
    end

    scenario 'after password is reset only new password can be used', js: true do
      fill_in 'user_password',              with: 'new-password'
      fill_in 'user_password_confirmation', with: 'new-password'
      click_button 'Reset Password'
      click_link 'Log out'
      click_link 'Log in'
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      click_button 'Log in'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq login_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: 'new-password'
      click_button 'Log in'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).not_to have_link('Log in', href: login_path)
      expect(current_path).to eq user_path(user)
    end
  end

  context 'non-existing email address' do
    scenario 're-render form with error message', js: true do
      visit login_path
      click_link 'Reset password'
      fill_in 'password_reset_email', with: 'non-existing@example.com'
      expect { click_button 'Submit' }.to change { ActionMailer::Base.deliveries.count }.by 0
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(current_path).to eq password_resets_path
    end
  end
end
