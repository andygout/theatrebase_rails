module FormHelper

  def apply_created_updated_outer_markup rows_markup
    "<div class='content-container'>"\
      "<table class='table'>"\
        "#{rows_markup}"\
      "</table>"\
    "</div>"
  end

  def compile_created_updated_markup values
    apply_created_updated_outer_markup values.map { |v| "<tr>"\
                                                          "<td class='description-text'>#{v[0]}</td><td>#{v[1]}</td>"\
                                                        "</tr>"
                                                  }.join('')
  end

  def format_datetime value
    value.strftime('%a, %d %b %Y at %H:%M')
  end

  def create_created_updated_markup var
    values = []
    created = !var.nil? && !var.created_at.nil? && !var.creator.nil? ?
                "#{format_datetime(var.created_at)} by #{var.creator.name}" :
                'TBC'
    updated = !var.nil? && !var.updated_at.nil? && !var.updater.nil? ?
                "#{format_datetime(var.updated_at)} by #{var.updater.name}" :
                'TBC'
    values << ['First created:', created]
    values << ['Last updated:', updated]
    compile_created_updated_markup(values)
  end

  def create_status_assigned_markup status
    assigned = status ? "#{format_datetime(status.created_at)} by #{status.assignor.name}" : 'TBC'
    compile_created_updated_markup([['Assigned:', assigned]])
  end

end
