def create_logged_in_user
  user = create :user
  login user
  return user
end

def login user
  visit login_path
  fill_in 'session_email',    with: "#{user.email}"
  fill_in 'session_password', with: "#{user.password}"
  click_button 'Log in'
end