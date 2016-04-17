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

  def compile_header_markup header_values
    "<tr>" + header_values.map { |v| "<th>#{v[:content]}</th>" }.join('').to_s + "</tr>"
  end

  def compile_colwidth_markup colwidth_values
    colwidth_values.map { |v| "<col width=#{v[:width]}%>" }.join('').to_s
  end

  def compile_rows row_values, header_values=nil, colwidth_values=nil
    rows_markup = row_values.map do |row_value|
      "<tr>" + row_value.map { |v| "<td#{apply_class(v[:class])}>#{v[:content]}</td>" }.join('').to_s + "</tr>"
    end

    header_markup = header_values ? compile_header_markup(header_values) : ''

    coldwidth_markup = colwidth_values ? compile_colwidth_markup(colwidth_values) : ''

    rows_markup = coldwidth_markup + header_markup + rows_markup.join('')
  end

  def create_content_container row_values
    bookend_div_tags(bookend_table_tags(compile_rows(row_values), 'content-table'), 'content-container').html_safe
  end

end
