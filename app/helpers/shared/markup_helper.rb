module Shared::MarkupHelper

  def join_arr array
    array.join('').to_s
  end

  def link_markup path, identifier, text
    "<a href='/#{path}/#{identifier}'>#{text}</a>"
  end

  def concat_attrs attrs
    ' ' + attrs.map{ |k, v| "#{k}='#{v}'" }.join(' ')
  end

  def bookend_tags tag, content, attrs = {}
    attrs.compact!
    "<#{tag}#{concat_attrs(attrs) if attrs.any?}>" +
      "#{content}" +
    "</#{tag}>"
  end

  def compile_header_markup header_data
    header_markup = join_arr(header_data.map { |v| bookend_tags('th', v[:content], { colspan: v[:colspan].to_i }) })
    bookend_tags('tr', header_markup)
  end

  def compile_colwidth_markup colwidth_data
    join_arr(colwidth_data.map { |v| "<col width=#{v[:width]}%>" })
  end

  def compile_data_cells data_cell_data
    join_arr(data_cell_data.map { |v| bookend_tags('td', v[:content], { class: v[:class] }) })
  end

  def compile_rows table_data
    rows_markup = table_data[:row_data].map do |data_cell_data|
        data_cells_markup = compile_data_cells(data_cell_data)
        bookend_tags('tr', data_cells_markup)
      end.join('')
    header_markup = table_data[:header_data] ? compile_header_markup(table_data[:header_data]) : ''
    coldwidth_markup = table_data[:colwidth_data] ? compile_colwidth_markup(table_data[:colwidth_data]) : ''
    coldwidth_markup + header_markup + rows_markup
  end

  def create_content_container row_data, el_id = nil
    table_markup = bookend_tags('table', compile_rows({ row_data: row_data }), { class: 'table content-table' })
    bookend_tags('div', table_markup, { id: el_id, class: 'content-container' }).html_safe
  end

end
