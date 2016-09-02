module Productions::TheatreHelper

  include Shared::MarkupHelper

  def get_theatre_content_label
    bookend_tags('div', 'Theatre', { class: 'content-label' })
  end

  def get_theatre_link theatre
    bookend_tags('div', link_markup('theatres', theatre.url, theatre.name), { class: 'content' })
  end

  def get_theatre_inner_markup theatre
    theatre_inner_markup = ''
    theatre_inner_markup << get_theatre_content_label
    theatre_inner_markup << get_theatre_link(theatre)
  end

  def get_theatre_markup theatre
    theatre_markup = bookend_tags('div', get_theatre_inner_markup(theatre), { id: 'theatre', class: 'content-wrapper' })
    @theatre = theatre_markup.html_safe
  end

end
