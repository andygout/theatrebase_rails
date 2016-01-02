LINK_REGEX = /\/([a-zA-Z0-9_\-]*)\/edit\?email=([a-zA-Z0-9%\.]*)/

def create_logged_in_user
  user = create :user
  log_in user
  user
end

def create_logged_in_super_admin_user
  super_admin_user = create :super_admin_user
  log_in super_admin_user
  super_admin_user
end

def create_logged_in_admin_user
  admin_user = create :admin_user
  log_in admin_user
  admin_user
end

def log_in user
  visit log_in_path
  fill_in 'session_email',    with: user.email
  fill_in 'session_password', with: user.password
  click_button 'Log in'
end

def create_user user
  visit new_user_path
  fill_in 'user_name',                  with: user[:name]
  fill_in 'user_email',                 with: user[:email]
  click_button 'Create User'
end

def user_edit_form name, email, password, password_confirmation
  fill_in 'user_name',                  with: name
  fill_in 'user_email',                 with: email
  fill_in 'user_password',              with: password
  fill_in 'user_password_confirmation', with: password_confirmation
end

def request_password_reset user
  visit log_in_path
  click_link 'Reset password'
  fill_in 'password_reset_email', with: user.email
  click_button 'Submit'
end

def acquire_token msg
  LINK_REGEX.match(msg)[1]
end

def acquire_email_address msg
  LINK_REGEX.match(msg)[2].gsub(/%40/, '@')
end

def click_resource_link msg, resource
  token = acquire_token msg
  user_email = acquire_email_address msg
  if resource == 'account_activation'
    visit edit_account_activation_path(token, email: user_email)
  elsif resource == 'password_reset'
    visit edit_password_reset_path(token, email: user_email)
  end
  User.find_by(email: user_email)
end
