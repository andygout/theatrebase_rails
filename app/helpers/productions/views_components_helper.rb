module Productions::ViewsComponentsHelper

  include Productions::DatesListingHelper
  include Shared::MarkupHelper

  def get_production_index_table
    return "<p class='title-text'>No productions yet</p>".html_safe if @productions.empty?

    row_values = @productions.map do |production|
      [
        { content: "#{link_markup('productions', production.id, production.title)}" },
        { content: listing_dates(production) }
      ]
    end

    header_values = [{ content: 'Productions', colspan: 2 }]

    colwidth_values = [{ width: 80 }, { width: 20 }]

    bookend_tags('table', compile_rows(row_values, header_values, colwidth_values), 'listing').html_safe
  end

end
