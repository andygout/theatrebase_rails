require 'rails_helper'

feature 'User new/create' do
  let!(:admin_user) { create_logged_in_admin_user }
  let(:super_admin_user) { create :super_admin_user }
  let(:user) { create :user }
  let(:user1_attrs) { attributes_for :user }
  let(:user2_attrs) { attributes_for :user }
  let(:invalid_user_attrs) { attributes_for :invalid_user }

  context 'accessing add new user form' do
    scenario 'can view link as admin user and super-admin user; not as non-admin user; not when logged out', js: true do
      visit root_path
      expect(page).to have_link('New user', href: new_user_path)
      click_link 'Log out'
      log_in super_admin_user
      expect(page).to have_link('New user', href: new_user_path)
      click_link 'Log out'
      log_in user
      expect(page).not_to have_link('New user', href: new_user_path)
      click_link 'Log out'
      expect(page).not_to have_link('New user', href: new_user_path)
    end

    scenario 'click on \'New user\' link; display new user page', js: true do
      visit root_path
      click_link 'New user'
      expect(page).to have_current_path new_user_path
    end
  end

  context 'logged in as admin user; submit add new user form using valid details' do
    scenario 'user created; redirect to home page with success message; account activation email sent; creator and updater associations (w/admin) created', js: true do
      visit new_user_path
      fill_in 'user_name',  with: user1_attrs[:name]
      fill_in 'user_email', with: user1_attrs[:email]
      expect { click_button 'Create User' }.to change { User.count }.by(1)
                                          .and change { ActionMailer::Base.deliveries.count }.by(1)
      user_email = acquire_email_address ActionMailer::Base.deliveries.last.to_s
      user = User.find_by(email: user_email)
      expect(user.creator).to eq admin_user
      expect(user.updater).to eq admin_user
      expect(admin_user.created_users).to include user
      expect(admin_user.updated_users).to include user
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_current_path root_path
    end
  end

  context 'logged in as admin user; submit add new user form using invalid details' do
    scenario 'invalid name given; re-renders form with error message', js: true do
      visit new_user_path
      fill_in 'user_name',  with: invalid_user_attrs[:name]
      fill_in 'user_email', with: user1_attrs[:email]
      expect { click_button 'Create User' }.to change { User.count }.by 0
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_content 'New user'
      expect(page).to have_current_path users_path
    end
  end

  context 'activation link' do
    before(:each) do
      create_user user1_attrs
      click_link 'Log out'
    end

    scenario 'user not activated and cannot log in if account not activated via emailed link', js: true do
      user_email = acquire_email_address ActionMailer::Base.deliveries.last.to_s
      new_user = User.find_by(email: user_email)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      password_digest = BCrypt::Password.create(user1_attrs[:password], cost: cost)
      new_user.update_attribute(:password_digest, password_digest)
      visit log_in_path
      fill_in 'session_email',    with: user1_attrs[:email]
      fill_in 'session_password', with: user1_attrs[:password]
      click_button 'Log In'
      expect(new_user.activated_at).to eq nil
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile', href: user_path(new_user))
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_current_path root_path
    end

    scenario 'activation link not valid if invalid token given', js: true do
      user_email = acquire_email_address ActionMailer::Base.deliveries.last.to_s
      visit edit_account_activation_path('invalid-token', email: user_email)
      user = User.find_by(email: user_email)
      expect(user.activated_at).to eq nil
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile', href: user_path(user))
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_current_path root_path
    end

    scenario 'activation link not valid if incorrect email given', js: true do
      msg = ActionMailer::Base.deliveries.last.to_s
      activation_token = acquire_token msg
      user_email = acquire_email_address msg
      visit edit_account_activation_path(activation_token, email: 'incorrect-email')
      user = User.find_by(email: user_email)
      expect(user.activated_at).to eq nil
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile', href: user_path(user))
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_current_path root_path
    end

    scenario 'activation link valid if valid token and correct email given', js: true do
      msg = ActionMailer::Base.deliveries.last.to_s
      user = click_resource_link msg, 'account_activation'
      account_activation_token = acquire_token msg
      expect(user.activated_at).not_to eq nil
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(page).to have_current_path edit_account_activation_path(account_activation_token, email: user.email)
    end
  end

  context 'setting password' do
    before(:each) do
      create_user user1_attrs
      msg = ActionMailer::Base.deliveries.last.to_s
      @new_user = click_resource_link msg, 'account_activation'
      @account_activation_token = acquire_token msg
    end

    scenario 'if password not set correctly existing creator and updater associations (w/admin) remain', js: true do
      fill_in 'user_password',              with: ''
      fill_in 'user_password_confirmation', with: ''
      click_button 'Set Password'
      user = User.find_by(email: @new_user.email)
      expect(user.creator).to eq admin_user
      expect(user.updater).to eq admin_user
      expect(admin_user.created_users).to include user
      expect(admin_user.updated_users).to include user
      expect(user.updated_users).not_to include user
      expect(page).to have_css '.alert-error'
      expect(page).to have_css '.field_with_errors'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_current_path account_activation_path(@account_activation_token)
    end

    scenario 'password is set by entering valid password and confirmation; existing creator association (w/admin) remains and updater association (w/itself) updated', js: true do
      fill_in 'user_password',              with: user2_attrs[:password]
      fill_in 'user_password_confirmation', with: user2_attrs[:password]
      click_button 'Set Password'
      user = User.find_by(email: @new_user.email)
      expect(user.creator).to eq admin_user
      expect(user.updater).to eq user
      expect(admin_user.created_users).to include user
      expect(user.updated_users).to include user
      expect(admin_user.updated_users).not_to include user
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).not_to have_css '.field_with_errors'
      expect(page).to have_current_path user_path(@new_user)
    end
  end

  context 'using newly set password to log in' do
    before(:each) do
      create_user user1_attrs
      @new_user = click_resource_link ActionMailer::Base.deliveries.last.to_s, 'account_activation'
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      password_digest = BCrypt::Password.create(user1_attrs[:password], cost: cost)
      @new_user.update_attribute(:password_digest, password_digest)
    end

    scenario 'once account activated and password updated only new details can be used', js: true do
      fill_in 'user_password',              with: user2_attrs[:password]
      fill_in 'user_password_confirmation', with: user2_attrs[:password]
      click_button 'Set Password'
      click_link 'Log out'
      visit log_in_path
      fill_in 'session_email',    with: user1_attrs[:email]
      fill_in 'session_password', with: user1_attrs[:password]
      click_button 'Log In'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_current_path log_in_path
      fill_in 'session_email',    with: user1_attrs[:email]
      fill_in 'session_password', with: user2_attrs[:password]
      click_button 'Log In'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(@new_user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(page).to have_current_path user_path(@new_user)
    end

    scenario 'password can contain leading and trailing whitespace', js: true do
      fill_in 'user_password',              with: ' ' + user2_attrs[:password] + ' '
      fill_in 'user_password_confirmation', with: ' ' + user2_attrs[:password] + ' '
      click_button 'Set Password'
      click_link 'Log out'
      visit log_in_path
      fill_in 'session_email',    with: user1_attrs[:email]
      fill_in 'session_password', with: user2_attrs[:password]
      click_button 'Log In'
      expect(page).to have_css '.alert-error'
      expect(page).not_to have_css '.alert-success'
      expect(page).to have_link('Log in', href: log_in_path)
      expect(page).not_to have_link('Profile')
      expect(page).not_to have_link('Log out', href: log_out_path)
      expect(page).to have_current_path log_in_path
      fill_in 'session_email',    with: user1_attrs[:email]
      fill_in 'session_password', with: ' ' + user2_attrs[:password] + ' '
      click_button 'Log In'
      expect(page).to have_css '.alert-success'
      expect(page).not_to have_css '.alert-error'
      expect(page).to have_link('Profile', href: user_path(@new_user))
      expect(page).to have_link('Log out', href: log_out_path)
      expect(page).not_to have_link('Log in', href: log_in_path)
      expect(page).to have_current_path user_path(@new_user)
    end
  end
end
