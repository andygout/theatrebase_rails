module Shared::FormsHelper

  include Shared::MarkupHelper

  def datetime_format datetime_value
    datetime_value.localtime.strftime('%a, %d %b %Y at %H:%M')
  end

  def created_updated_text at, by
    at && by ? "#{datetime_format(at)} by #{by.name} (#{by.email})" : 'TBC'
  end

  def get_created_updated_info var
    created = created_updated_text(var.created_at, var.creator)
    updated = created_updated_text(var.updated_at, var.updater)
    row_values = [
        [{ content: 'First created:' }, { content: created }],
        [{ content: 'Last updated:' }, { content: updated }]
      ]
    @created_updated_info = create_content_container(row_values)
  end

  def get_status_assigned_info status
    assigned = status ?
      "#{datetime_format(status.created_at)} by #{status.assignor.name} (#{status.assignor.email})" :
      'TBC'
    row_values = [[{ content: 'Assigned:' }, { content: assigned }]]
    @status_assigned_info = create_content_container(row_values)
  end

end
