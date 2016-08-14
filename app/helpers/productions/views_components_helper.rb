module Productions::ViewsComponentsHelper

  include Productions::DatesListingHelper
  include Shared::MarkupHelper

  def get_production_index_table
    return "<h1 class='title-text'>No productions yet</h1>".html_safe if @productions.empty?

    row_values = @productions.map do |production|
      [
        { content: link_markup('productions', "#{production.id}/#{production.url}", production.title) },
        { content: production.theatre.name },
        { content: listing_dates(production) }
      ]
    end
    header_values = [{ content: 'Productions', colspan: 3 }]
    colwidth_values = [{ width: 30 }, { width: 50 }, { width: 20 }]
    rows_markup = compile_rows(row_values, header_values, colwidth_values)
    bookend_tags('table', rows_markup, 'table listing', 'productions-index').html_safe
  end

end
