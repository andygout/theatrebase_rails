module SharedViewsComponentsHelper

  def get_content_header model
    @content_header = "<p class='content-label content-header'>#{model.upcase}</p>".html_safe
  end

  def get_user_page_title user
    @page_title = "#{user.name} (#{user.email})"
  end

end
