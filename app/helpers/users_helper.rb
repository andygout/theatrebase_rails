module UsersHelper

  def logged_in_user
    unless logged_in?
      store_location
      flash[:error] = 'Please log in'
      redirect_to log_in_path
    end
  end

  def valid_admin_status_user? user
    current_user.super_admin && !user.super_admin
  end

  def valid_show_user? user
    current_user?(user) || super_or_admin?(current_user)
  end

  def valid_destroy_user? user
    delete_self_and_not_super_admin?(user) ||
    super_admin_or_admin_delete_non_admin?(user) ||
    super_admin_delete_admin?(user)
  end

  def delete_self_and_not_super_admin? user
    current_user?(user) && !current_user.super_admin
  end

  def super_admin_or_admin_delete_non_admin? user
    super_or_admin?(current_user) && not_super_or_admin?(user)
  end

  def super_admin_delete_admin? user
    user.admin ? (current_user.super_admin && user.admin.status) : false
  end

  def super_or_admin? user
    (user.super_admin || user.admin) ? (user.super_admin || user.admin.status) : false
  end

  def not_super_or_admin? user
    (user.super_admin || user.admin) ? (!user.super_admin && !user.admin.status) : true
  end

end
