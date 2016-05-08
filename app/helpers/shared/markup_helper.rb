module Shared::MarkupHelper

  def link_markup path, id, text
    "<a href='/#{path}/#{id}'>#{text}</a>"
  end

  def apply_class class_string
    " class='#{class_string}'" if class_string
  end

  def add_colspan cols
    cols ? " colspan='#{cols}'" : ''
  end

  def bookend_tags element, markup, element_class=nil
    element_class = element_class ? " class='#{element_class}'" : ''
    "<#{element}#{element_class}>#{markup}</#{element}>"
  end

  def compile_header_markup header_values
    "<tr>" + header_values.map { |v| "<th#{add_colspan(v[:colspan])}>#{v[:content]}</th>" }.join('').to_s + "</tr>"
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
    table_markup = bookend_tags('table', compile_rows(row_values), 'table content-table')
    bookend_tags('div', table_markup, 'content-container').html_safe
  end

end
