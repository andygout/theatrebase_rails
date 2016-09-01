require 'rails_helper'

feature 'User password reset' do
  let(:unactivated_user) { create :unactivated_user }
  let(:user) { create :user }

  context 'submitting request for password reset link email' do
    scenario 'using non-existing email address: re-render form with error message', js: true do
      visit log_in_path
      click_link 'Reset password'
      fill_in 'password_reset_email', with: 'non-existing@example.com'
      expect { click_button 'Submit' }.to change { ActionMailer::Base.deliveries.count }.by 0
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_current_path password_resets_path
    end

    scenario 'as unactivated user: redirect to home page with instructions to first activate account', js: true do
      visit log_in_path
      click_link 'Reset password'
      fill_in 'password_reset_email', with: unactivated_user.email
      expect { click_button 'Submit' }.to change { ActionMailer::Base.deliveries.count }.by 0
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_current_path root_path
    end

    scenario 'as activated user: redirect to home page with success message; password reset email sent', js: true do
      visit log_in_path
      click_link 'Reset password'
      fill_in 'password_reset_email', with: user.email
      expect { click_button 'Submit' }.to change { ActionMailer::Base.deliveries.count }.by 1
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_current_path root_path
    end
  end

  context 'clicking password reset link' do
    before(:each) do
      request_password_reset user
      @msg = ActionMailer::Base.deliveries.last.to_s
      @password_reset_token = acquire_token @msg
    end

    scenario 'not valid if invalid token given', js: true do
      user_email = acquire_email_address @msg
      visit edit_password_reset_path('invalid-token', email: user_email)
      expect(page).to have_current_path root_path
    end

    scenario 'not valid if invalid email given', js: true do
      visit edit_password_reset_path(@password_reset_token, email: 'incorrect-email')
      expect(page).to have_current_path root_path
    end

    scenario 'valid if valid token and correct email given', js: true do
      user = click_resource_link @msg, 'password_reset'
      expect(find('#email', :visible => false).value).to eq user.email
      expect(page).to have_current_path edit_password_reset_path(@password_reset_token, email: user.email)
    end

    scenario 'redirects to home page if user not activated', js: true do
      user.update_attribute(:activated_at, nil)
      click_resource_link @msg, 'password_reset'
      expect(page).to have_current_path root_path
    end

    scenario 'redirects to link request page if token has expired', js: true do
      user.update_attribute(:reset_sent_at, 3.hours.ago)
      click_resource_link @msg, 'password_reset'
      expect(page).to have_css '.alert-error'
      expect(page).to have_current_path new_password_reset_path
    end
  end

  context 'submitting password reset form' do
    before(:each) do
      request_password_reset user
      msg = ActionMailer::Base.deliveries.last.to_s
      @password_reset_token = acquire_token msg
      user = click_resource_link msg, 'password_reset'
    end

    scenario 'password cannot be reset without entering valid new password & confirmation', js: true do
      fill_in 'user_password',              with: ''
      fill_in 'user_password_confirmation', with: ''
      click_button 'Reset Password'
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_current_path password_reset_path(@password_reset_token)
    end

    scenario 'password is reset by entering valid password and confirmation', js: true do
      fill_in 'user_password',              with: 'new-password'
      fill_in 'user_password_confirmation', with: 'new-password'
      click_button 'Reset Password'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_current_path user_path(user)
    end

    scenario 'after password is reset only new password can be used', js: true do
      fill_in 'user_password',              with: 'new-password'
      fill_in 'user_password_confirmation', with: 'new-password'
      click_button 'Reset Password'
      click_link 'Log out'
      click_link 'Log in'
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: user.password
      click_button 'Log In'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_current_path log_in_path
      fill_in 'session_email',    with: user.email
      fill_in 'session_password', with: 'new-password'
      click_button 'Log In'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(page).to have_current_path user_path(user)
    end
  end
end
