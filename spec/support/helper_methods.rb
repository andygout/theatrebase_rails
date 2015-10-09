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