module UsersHelper

  def logged_in_user
    unless logged_in?
      store_location
      flash[:error] = 'Please log in'
      redirect_to log_in_path
    end
  end

  def valid_show_user? user
    current_user?(user) || current_user.admin
  end

  def valid_destroy_user? user
    current_user?(user) || (current_user.admin && !user.admin)
  end

end
