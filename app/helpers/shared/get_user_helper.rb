module Shared::GetUserHelper

  def get_user id
    @user = ['new', 'create'].include?(params[:action]) ? User.new : User.find(id)
  end

  def get_user_by_email email
    @user = User.find_by_email(email)
  end

end
