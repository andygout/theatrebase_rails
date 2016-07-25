module Shared::ViewsComponentsHelper

  def get_user_page_title user
    "#{user.name} (#{user.email})"
  end

end
