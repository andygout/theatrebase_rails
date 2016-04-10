module Users::ViewsComponentsHelper

  include Shared::MarkupHelper

  def admin_status_wording user
    user.super_admin ? 'Super admin' : user.admin ? 'Admin' : 'Standard'
  end

  def suspension_status_wording user
    user.suspension ? 'Suspended' : 'Not suspended'
  end

  def admin_status_class user
    user.super_admin ? 'gold' : user.admin ? 'silver' : 'bronze'
  end

  def suspension_status_class user
    user.suspension ? 'suspended' : 'not-suspended'
  end

  def get_status_info
    values =  [
                ['Admin status:', admin_status_wording(@user)],
                ['Suspension status:', suspension_status_wording(@user)]
              ]
    @status_info = create_content_container(values)
  end

  def get_user_index_table
    row_values = @users.map do |user|
      [
        { content: "<a href='/users/#{user.id}'>#{user.name}</a> (#{user.email})" },
        { content: admin_status_wording(user), class: admin_status_class(user) },
        { content: suspension_status_wording(user), class: suspension_status_class(user) }
      ]
    end

    header_values = [{ content: 'User' }, { content: 'Admin status' }, { content: 'Suspension status' }]

    colwidth_values = [{ width: 60 }, { width: 20 }, { width: 20 }]

    @user_index_table = bookend_table_tags(
        compile_user_index_table_rows(row_values, header_values, colwidth_values),
        'listing'
      ).html_safe
  end

end
