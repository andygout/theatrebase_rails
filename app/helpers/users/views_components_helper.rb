module Users::ViewsComponentsHelper

  include MarkupHelper

  def get_status_info
    admin_status = @user.super_admin ? 'Super admin' : @user.admin ? 'Admin' : 'Standard'
    suspension_status = @user.suspension ? 'Suspended' : 'Not suspended'
    values = [['Admin status:', admin_status], ['Suspension status:', suspension_status]]
    @status_info = create_content_container(values)
  end

end
