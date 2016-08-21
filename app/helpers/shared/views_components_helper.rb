module Shared::ViewsComponentsHelper

  include Productions::DatesListingHelper
  include Shared::MarkupHelper

  def get_page_title model, page_title
    @page_title = ['new', 'create'].include?(params[:action]) ? "New #{model.downcase}" : page_title
  end

  def get_user_page_title
    "#{@user.name} (#{@user.email})"
  end

  def get_browser_tab_suffix model
    model === 'Production' ? listing_dates(@production) : model.downcase
  end

  def get_browser_tab model
    edit_page = ['edit', 'update'].include?(params[:action])
    @browser_tab = "#{'Edit: ' if edit_page}#{@page_title} (#{get_browser_tab_suffix(model)})"
  end

  def get_content_header model
    @content_header = model.upcase
  end

  def get_production_index_table productions
    return @no_productions_msg = "<h1 class='title-text'>No productions yet</h1>".html_safe if productions.empty?

    row_values = productions.map do |production|
      [
        { content: link_markup('productions', "#{production.id}/#{production.url}", production.title) },
        { content: production.theatre.name },
        { content: listing_dates(production) }
      ]
    end
    header_values = [{ content: 'Productions', colspan: 3 }]
    colwidth_values = [{ width: 30 }, { width: 50 }, { width: 20 }]
    rows_markup = compile_rows(row_values, header_values, colwidth_values)
    @production_index_table = bookend_tags('table', rows_markup, 'table listing', 'productions-index').html_safe
  end

end
