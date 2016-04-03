module FormsHelper

  include MarkupHelper

  def datetime_format datetime_value
    datetime_value.strftime('%a, %d %b %Y at %H:%M')
  end

  def created_updated_text at, by
    at && by ? "#{datetime_format(at)} by #{by.name} (#{by.email})" : 'TBC'
  end

  def get_created_updated_info var
    created = created_updated_text(var.created_at, var.creator)
    updated = created_updated_text(var.updated_at, var.updater)
    values = [['First created:', created], ['Last updated:', updated]]
    @created_updated_info = bookend_div_tags(bookend_table_tags(compile_rows(values)), 'content-container').html_safe
  end

  def get_status_assigned_info status
    assigned = status ?
      "#{datetime_format(status.created_at)} by #{status.assignor.name} (#{status.assignor.email})" :
      'TBC'
    markup = bookend_div_tags(bookend_table_tags(compile_rows([['Assigned:', assigned]])), 'content-container')
    @status_assigned_info = markup.html_safe
  end

end
