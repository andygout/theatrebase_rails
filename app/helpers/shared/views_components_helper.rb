module Shared::ViewsComponentsHelper

  def get_views_components model
    @content_header = model.upcase
  end

  def get_user_page_title user
    "#{user.name} (#{user.email})"
  end

end
