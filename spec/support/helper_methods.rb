LINK_REGEX = /\/([a-zA-Z0-9_\-]*)\/edit\?email=([a-zA-Z0-9%\.]*)/

def create_logged_in_user
  user = create :user
  login user
  return user
end

def create_logged_in_admin_user
  admin_user = create :admin_user
  login admin_user
  return admin_user
end

def login user
  visit login_path
  fill_in 'session_email',    with: "#{user.email}"
  fill_in 'session_password', with: "#{user.password}"
  click_button 'Log in'
end

def signup user
  visit signup_path
  fill_in 'user_name',                  with: user[:name]
  fill_in 'user_email',                 with: user[:email]
  fill_in 'user_password',              with: user[:password]
  fill_in 'user_password_confirmation', with: user[:password_confirmation]
  click_button 'Create User'
end

def acquire_token msg
  LINK_REGEX.match(msg)[1]
end

def acquire_email_address msg
  LINK_REGEX.match(msg)[2].gsub(/%40/, '@')
end

def click_activation_link msg
  activation_token = acquire_token msg
  user_email = acquire_email_address msg
  visit edit_account_activation_path(activation_token, email: user_email)
  User.find_by(email: user_email)
end
