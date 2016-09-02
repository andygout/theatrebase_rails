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
    user.suspension ? 'negative' : 'positive'
  end

  def get_status_info
    row_data = [
        [
          { content: 'Admin status:' },
          { content: admin_status_wording(@user), class: admin_status_class(@user) }
        ],
        [
          { content: 'Suspension status:' },
          { content: suspension_status_wording(@user), class: suspension_status_class(@user) }
        ]
      ]

    @status_info = create_content_container(row_data, 'status-info')
  end

  def get_user_table_header_data
    [
      { content: 'User' },
      { content: 'Email address' },
      { content: 'Admin status' },
      { content: 'Suspension status' }
    ]
  end

  def get_user_table_row_data users
    users.map do |user|
      [
        { content: link_markup('users', user.id, user.name) },
        { content: user.email },
        { content: admin_status_wording(user), class: admin_status_class(user) },
        { content: suspension_status_wording(user), class: suspension_status_class(user) }
      ]
    end
  end

  def get_user_table_data users
    {
      header_data: get_user_table_header_data,
      colwidth_data: [{ width: 30 }, { width: 30 }, { width: 20 }, { width: 20 }],
      row_data: get_user_table_row_data(users)
    }
  end

  def get_user_table users
    rows_markup = compile_rows(get_user_table_data(users))
    @user_table = bookend_tags('table', rows_markup, { id: 'users-index', class: 'table listing' }).html_safe
  end

end
