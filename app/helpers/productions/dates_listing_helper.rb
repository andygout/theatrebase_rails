module Productions::DatesListingHelper

  include Productions::DatesHelper
  include Shared::MarkupHelper

  def get_span_class p
    booking_until?(p) ? 'emphasis-text' : nil
  end

  def get_first_listing_date p
    bookend_tags('span', date_listing_format(p.first_date))
  end

  def get_last_listing_date p
    return bookend_tags('span', 'TBC', { class: 'emphasis-text' }) if last_date_tbc?(p)
    bookend_tags('span', date_listing_format(p.last_date), { class: get_span_class(p) })
  end

  def listing_dates p
    return bookend_tags('span', p.dates_tbc_note || 'Dates TBC', { class: 'emphasis-text' }) if dates_tbc?(p)

    if single_date?(p)
      return bookend_tags('span', 'Dates TBC', { class: 'emphasis-text' }) if last_date_tbc?(p)
      return bookend_tags('span', "#{date_listing_format(p.first_date)} only", { class: get_span_class(p) })
    end

    dates = ''
    dates << get_first_listing_date(p)
    dates << ' - '
    dates << get_last_listing_date(p)
  end

end
