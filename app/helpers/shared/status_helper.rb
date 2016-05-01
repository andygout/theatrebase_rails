module Shared::StatusHelper

  include Shared::FormsHelper
  include Shared::ViewsComponentsHelper
  include Users::ViewsComponentsHelper

  def get_status_edit_components status_type
    get_user_page_title @user
    get_content_header 'user'
    get_status_info
    get_status_assigned_info(@user.send(status_type) || nil)
  end

    private

    def user_status_params status_type
      params
        .require(:user)
        .permit("#{status_type}_attributes": [:_destroy, :id])
        .deep_merge("#{status_type}_attributes": { assignor_id: current_user.id })
    end

end