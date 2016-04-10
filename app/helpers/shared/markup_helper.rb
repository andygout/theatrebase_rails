module Shared::MarkupHelper

  def apply_class class_string
    " class='#{class_string}'" if class_string
  end

  def bookend_div_tags table_markup, div_class=nil
    div_class = div_class ? " class='#{div_class}'" : ''
    "<div#{div_class}>"\
      "#{table_markup}"\
    "</div>"
  end

  def bookend_table_tags rows_markup, table_class=nil
    table_class = table_class ? " #{table_class}" : ''
    "<table class='table#{table_class}'>"\
      "#{rows_markup}"\
    "</table>"\
  end

  def compile_rows values
    values.map  { |v| "<tr>"\
                        "<td class='description-text'>#{v[0]}</td>"\
                        "<td#{apply_class(v[2])}>#{v[1]}</td>"\
                      "</tr>"
                }.join('')
  end

  def create_content_container values
    bookend_div_tags(bookend_table_tags(compile_rows(values)), 'content-container').html_safe
  end

end
