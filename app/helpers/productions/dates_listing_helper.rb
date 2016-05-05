module Productions::DatesListingHelper

  include Productions::DatesHelper
  include Shared::MarkupHelper

  def get_first_listing_date p
    bookend_span_tags(date_listing_format(p.first_date))
  end

  def get_last_listing_date p
    return bookend_span_tags('TBC', 'emphasis-text') if last_date_tbc?(p)
    span_class = booking_until?(p) ? 'emphasis-text' : nil
    bookend_span_tags(date_listing_format(p.last_date), span_class)
  end

  def listing_dates p
    return bookend_span_tags(p.dates_tbc_note || 'Dates TBC', 'emphasis-text') if dates_tbc?(p)

    if single_date?(p)
      return bookend_span_tags('Dates TBC', 'emphasis-text') if last_date_tbc?(p)
      span_class = booking_until?(p) ? 'emphasis-text' : nil
      return bookend_span_tags(date_listing_format(p.first_date) + ' only', span_class)
    end

    dates = ''
    dates << get_first_listing_date(p)
    dates << ' - '
    dates << get_last_listing_date(p)
  end

end

