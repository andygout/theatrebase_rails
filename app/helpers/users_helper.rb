module UsersHelper

  def admin? user
    Admin.exists?(user_id: user.id)
  end

end
