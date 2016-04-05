module Productions::DatesShowHelper

  include MarkupHelper

  def booking_until p
    p.dates_info == 1
  end

  def last_date_tbc p
    p.dates_info == 2
  end

  def dates_tbc p
    p.dates_info == 3
  end

  def single_date p
    p.press_date ?
      [p.first_date, p.press_date, p.last_date].uniq.count == 1 :
      p.first_date == p.last_date
  end

  def single_date_tbc p
    single_date(p) && last_date_tbc(p)
  end

  def dates_single_date_tbc p
    dates_tbc(p) || single_date_tbc(p)
  end

  def open_first_date p
    p.first_date == p.press_date
  end

  def date_format date_value
    begin
      date_value.strftime('%a, %d %b %Y') if Date.parse(date_value.to_s)
    rescue ArgumentError, NoMethodError
      date_value
    end
  end

  def get_first_date p
    wording = p.press_date ?
      !open_first_date(p) ? 'First preview:' : 'Opening performance:' :
      p.press_date_tbc ? 'First preview:' : 'First performance:'
    [wording, date_format(p.first_date)]
  end

  def get_press_date p
    date_value = p.second_press_date ?
      "#{date_format(p.press_date)} and #{date_format(p.second_press_date)}" :
      date_format(p.press_date)

    wording = !p.press_date_wording.present? ?
      "Press performance#{:s if p.second_press_date}:" :
      "#{p.press_date_wording}:"

    !p.press_date_tbc ?
      open_first_date(p) ? nil : [wording, date_value] :
      [wording, 'TBC', 'emphasis-text']
  end

  def get_last_date p
    return ['Booking until:', date_format(p.last_date), 'emphasis-text'] if booking_until(p)
    return ['Last performance:', 'TBC', 'emphasis-text'] if last_date_tbc(p)
    ['Last performance:', date_format(p.last_date)]
  end

  def dates_table p
    if dates_tbc(p) || single_date_tbc(p)
      dates_tbc_note = ": #{p.dates_tbc_note}" if p.dates_tbc_note && dates_single_date_tbc(p)
      dates_tbc_row = "<tr><td class='emphasis-text'>TBC#{dates_tbc_note}</td></tr>" if dates_single_date_tbc(p)
      return bookend_table_tags(dates_tbc_row, 'dates-table')
    end

    if single_date(p)
      booking_until_text = ' (booking until)' if booking_until(p)
      booking_until_class = booking_until(p) ? 'emphasis-text' : nil
      row_values = ["Performs#{booking_until_text}:", date_format(p.first_date), booking_until_class]
      return bookend_table_tags(compile_rows([row_values]), 'dates-table')
    end

    dates = []
    dates << get_first_date(p)
    dates << get_press_date(p) if p.press_date || p.press_date_tbc
    dates << get_last_date(p) unless single_date(p)
    bookend_table_tags(compile_rows(dates.compact), 'dates-table')
  end

  def get_dates p
    dates_note = p.dates_note.present? ? "<p class='note-text emphasis-text'>#{p.dates_note}</p>" : ''
    dates_markup = "<p class='content-label'>Dates</p>" + dates_table(p) + dates_note
    @dates = dates_markup.html_safe
  end

end
