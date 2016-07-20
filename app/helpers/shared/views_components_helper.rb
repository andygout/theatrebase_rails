module Shared::ViewsComponentsHelper

  def get_content_header model
    @content_header = "<div class='content-label content-header'>#{model.upcase}</div>".html_safe
  end

  def get_user_page_title user
    @page_title = "#{user.name} (#{user.email})"
  end

end
