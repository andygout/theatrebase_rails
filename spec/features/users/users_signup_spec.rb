require 'rails_helper'

feature 'User sign-up' do
  context 'valid details' do
    let(:user) { attributes_for :user }
    scenario 'user created; redirect to home page with success message; account activation email sent', js: true do
      visit signup_path
      fill_in 'user_name',                  with: "#{user[:name]}"
      fill_in 'user_email',                 with: "#{user[:email]}"
      fill_in 'user_password',              with: "#{user[:password]}"
      fill_in 'user_password_confirmation', with: "#{user[:password_confirmation]}"
      expect { click_button 'Create User' }.to change { User.count }.by(1)
                                          .and change { ActionMailer::Base.deliveries.count }.by(1)
      expect(page).to have_css 'p.alert-success'
      expect(page).not_to have_css 'p.alert-error'
      expect(page).not_to have_css 'li.field_with_errors'
      expect(current_path).to eq root_path
    end

    scenario 'user not activated and cannot log in if account not activated via emailed link', js: true do
      signup user
      msg = ActionMailer::Base.deliveries.last.to_s
      user_email = acquire_email_address msg
      user = User.find_by(email: user_email)
      expect(user.activated?).to eq false
      login user
      expect(page).to have_css '.alert-error'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(user.id))
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq login_path
    end

    scenario 'activation link not valid if invalid token given', js: true do
      signup user
      msg = ActionMailer::Base.deliveries.last.to_s
      user_email = acquire_email_address msg
      visit edit_account_activation_path('invalid-token', email: user_email)
      user = User.find_by(email: user_email)
      expect(user.activated?).to eq false
      expect(page).to have_css '.alert-error'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(user.id))
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq root_path
    end

    scenario 'activation link not valid if incorrect email given', js: true do
      signup user
      msg = ActionMailer::Base.deliveries.last.to_s
      activation_token = acquire_token msg
      user_email = acquire_email_address msg
      visit edit_account_activation_path(activation_token, email: 'incorrect-email')
      user = User.find_by(email: user_email)
      expect(user.activated?).to eq false
      expect(page).to have_css '.alert-error'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile', href: user_path(user.id))
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq root_path
    end

    scenario 'activation link valid if valid token and correct email given', js: true do
      signup user
      msg = ActionMailer::Base.deliveries.last.to_s
      activation_token = acquire_token msg
      user_email = acquire_email_address msg
      visit edit_account_activation_path(activation_token, email: user_email)
      user = User.find_by(email: user_email)
      expect(user.activated?).to eq true
      expect(page).to have_css '.alert-success'
      expect(page).to have_link('Profile', href: user_path(user.id))
      expect(page).to have_link('Log out', href: logout_path)
      expect(page).not_to have_link('Log in', href: login_path)
      expect(current_path).to eq user_path(user)
    end
  end

  context 'invalid details' do
    let(:invalid_user) { attributes_for :invalid_user }
    scenario 're-render form with error message', js: true do
      visit signup_path
      fill_in 'user_name',                  with: "#{invalid_user[:name]}"
      fill_in 'user_email',                 with: "#{invalid_user[:email]}"
      fill_in 'user_password',              with: "#{invalid_user[:password]}"
      fill_in 'user_password_confirmation', with: "#{invalid_user[:password_confirmation]}"
      expect { click_button 'Create User' }.to change { User.count }.by 0
      expect(page).to have_css 'p.alert-error'
      expect(page).to have_css 'li.field_with_errors'
      expect(page).not_to have_css 'p.alert-success'
      expect(page).to have_link('Log in', href: login_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: logout_path)
      expect(current_path).to eq users_path
    end
  end
end
