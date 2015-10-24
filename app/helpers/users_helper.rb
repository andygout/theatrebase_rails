module UsersHelper

  def admin? user
    Admin.exists?(user_id: user.id)
  end

  def valid_show_user? user
    current_user?(user) || admin?(current_user)
  end

  def valid_destroy_user? user
    current_user?(user) || (admin?(current_user) && !admin?(user))
  end

end
