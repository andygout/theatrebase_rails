module Productions::TheatreHelper

  include Shared::MarkupHelper

  def get_theatre theatre
    theatre_inner_markup = ''
    theatre_inner_markup << bookend_tags('div', 'Theatre', 'content-label')
    theatre_inner_markup << bookend_tags('div', link_markup('theatres', theatre.url, theatre.name), 'content')
    theatre_markup = bookend_tags('div', theatre_inner_markup, 'content-wrapper', 'theatre')
    @theatre = theatre_markup.html_safe
  end

end
