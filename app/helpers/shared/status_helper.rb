module Shared::StatusHelper

  include Shared::FormsHelper
  include Shared::ViewsComponentsHelper
  include Users::ViewsComponentsHelper

  def get_status_edit_components status_type
    @page_title = "Edit #{status_type.to_s} status: #{get_user_page_title(@user)}"
    @browser_tab = "#{@page_title} (user)"
    @content_header = 'USER'
    get_status_info
    get_status_assigned_info(@user.send(status_type) || nil)
  end

    private

    def get_user id
      @user = User.find(id)
    end

    def user_status_params status_type
      params
        .require(:user)
        .permit("#{status_type}_attributes": [:_destroy, :id])
        .deep_merge("#{status_type}_attributes": { assignor_id: current_user.id })
    end

end
