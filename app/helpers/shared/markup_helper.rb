module Shared::MarkupHelper

  def join_arr array
    array.join('').to_s
  end

  def link_markup path, identifier, text
    "<a href='/#{path}/#{identifier}'>#{text}</a>"
  end

  def bookend_tags element, markup, el_class = nil, el_id = nil, colspan = nil
    el_class = el_class ? " class='#{el_class}'" : ''
    el_id = el_id ? " id='#{el_id}'" : ''
    colspan = colspan ? " colspan='#{colspan}'" : ''
    "<#{element}#{el_id}#{el_class}#{colspan}>#{markup}</#{element}>"
  end

  def compile_header_markup header_values
    header_markup = join_arr(header_values.map { |v| bookend_tags('th', v[:content], nil, nil, v[:colspan]) })
    bookend_tags('tr', header_markup)
  end

  def compile_colwidth_markup colwidth_values
    join_arr(colwidth_values.map { |v| "<col width=#{v[:width]}%>" })
  end

  def compile_rows row_values, header_values = nil, colwidth_values = nil
    rows_markup = row_values.map do |data_cell_values|
      data_cells_markup = join_arr(data_cell_values.map { |v| bookend_tags('td', v[:content], v[:class]) })
      bookend_tags('tr', data_cells_markup)
    end
    header_markup = header_values ? compile_header_markup(header_values) : ''
    coldwidth_markup = colwidth_values ? compile_colwidth_markup(colwidth_values) : ''
    coldwidth_markup + header_markup + rows_markup.join('')
  end

  def create_content_container row_values, el_id = nil
    table_markup = bookend_tags('table', compile_rows(row_values), 'table content-table')
    bookend_tags('div', table_markup, 'content-container', el_id).html_safe
  end

end
