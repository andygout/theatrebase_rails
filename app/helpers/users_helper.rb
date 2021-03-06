module UsersHelper

  def logged_in_user
    unless logged_in?
      store_location
      flash[:error] = 'PLEASE LOG IN'
      redirect_to log_in_path
    end
  end

  def not_suspended_user
    if current_user.suspension
      log_out
      flash[:error] = 'ACCOUNT SUSPENDED'
      validate_user false
    end
  end

  def validate_user user_valid
    unless user_valid
      flash[:error] ||= 'ACCESS DENIED'
      redirect_to root_path
    end
  end

  def valid_admin_status_assignor? user
    current_user.super_admin && !user.super_admin
  end

  def valid_suspension_status_assignor? user
    lower_rank?(user)
  end

  def valid_destroy_user? user
    delete_self_and_not_super_admin?(user) || lower_rank?(user)
  end

  def valid_show_user? user
    current_user?(user) || lower_rank?(user)
  end

  def delete_self_and_not_super_admin? user
    current_user?(user) && !current_user.super_admin
  end

  def lower_rank? user
    (current_user.super_admin && !user.super_admin) ||
    (current_user.admin && !user.super_admin && !user.admin)
  end

  def super_or_admin? user
    user.super_admin || user.admin
  end

end
