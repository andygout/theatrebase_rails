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
    row_values = [
        [
          { content: 'Admin status:' },
          { content: admin_status_wording(@user), class: admin_status_class(@user) }
        ],
        [
          { content: 'Suspension status:' },
          { content: suspension_status_wording(@user), class: suspension_status_class(@user) }
        ]
      ]

    @status_info = create_content_container(row_values)
  end

  def get_user_index_table
    row_values = @users.map do |user|
      [
        { content: link_markup('users', user.id, user.name) },
        { content: user.email },
        { content: admin_status_wording(user), class: admin_status_class(user) },
        { content: suspension_status_wording(user), class: suspension_status_class(user) }
      ]
    end

    header_values = [
      { content: 'User' },
      { content: 'Email address' },
      { content: 'Admin status' },
      { content: 'Suspension status' }
    ]

    colwidth_values = [{ width: 30 }, { width: 30 }, { width: 20 }, { width: 20 }]

    rows_markup = compile_rows(row_values, header_values, colwidth_values)

    bookend_tags('table', rows_markup, 'listing').html_safe
  end

end
