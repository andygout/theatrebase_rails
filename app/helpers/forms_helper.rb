module FormsHelper

  include MarkupHelper

  def datetime_format datetime_value
    datetime_value.strftime('%a, %d %b %Y at %H:%M')
  end

  def create_created_updated_markup var
    created = !var.nil? && !var.created_at.nil? && !var.creator.nil? ?
                "#{datetime_format(var.created_at)} by #{var.creator.name}" :
                'TBC'

    updated = !var.nil? && !var.updated_at.nil? && !var.updater.nil? ?
                "#{datetime_format(var.updated_at)} by #{var.updater.name}" :
                'TBC'

    values = [['First created:', created], ['Last updated:', updated]]
    bookend_div_tags(bookend_table_tags(compile_rows(values)), 'content-container')
  end

  def create_status_assigned_markup status
    assigned = status ? "#{datetime_format(status.created_at)} by #{status.assignor.name}" : 'TBC'
    bookend_div_tags(bookend_table_tags(compile_rows([['Assigned:', assigned]])), 'content-container')
  end

end
