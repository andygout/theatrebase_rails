module Shared::FormsHelper

  include Shared::MarkupHelper

  def datetime_format datetime_value
    datetime_value.localtime.strftime('%a, %d %b %Y at %H:%M')
  end

  def name_markup user
    valid_show_user?(user) ? link_markup('users', user.id, user.name) : user.name
  end

  def created_updated_text at, by
    at && by ? "#{datetime_format(at)} by #{name_markup(by)}" : 'TBC'
  end

  def get_created_updated_info instance
    created = created_updated_text(instance.created_at, instance.creator)
    updated = created_updated_text(instance.updated_at, instance.updater)
    row_values = [
        [{ content: 'First created:' }, { content: created }],
        [{ content: 'Last updated:' }, { content: updated }]
      ]
    @created_updated_info = create_content_container(row_values, 'created-updated-info')
  end

  def get_status_assigned_info status
    at = status ? status.created_at : nil
    by = status ? status.assignor : nil
    assigned = created_updated_text(at, by)
    row_values = [[{ content: 'Assigned:' }, { content: assigned }]]
    @status_assigned_info = create_content_container(row_values, 'assignment-info')
  end

end
