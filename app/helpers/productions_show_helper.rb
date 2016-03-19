module ProductionsShowHelper

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

  def get_first_date p
    wording = p.press_date ?
      !open_first_date(p) ? 'First preview:' : 'Opening performance:' :
      p.press_date_tbc ? 'First preview:' : 'First performance:'
    [wording, p.first_date]
  end

  def get_press_date p
    date_value = p.second_press_date ? "#{format(p.press_date)} and #{format(p.second_press_date)}" : p.press_date
    wording = !p.press_date_wording.present? ?
      "Press performance#{:s if p.second_press_date}:" :
      "#{p.press_date_wording}:"
    !p.press_date_tbc ?
      open_first_date(p) ? nil : [wording, date_value] :
      [wording, 'TBC', true]
  end

  def get_last_date p
    return ['Booking until:', p.last_date, true] if booking_until(p)
    return ['Last performance:', 'TBC', true] if last_date_tbc(p)
    ['Last performance:', p.last_date]
  end

  def format date_value
    begin
      date_value.strftime('%a, %d %b %Y') if Date.parse(date_value.to_s)
    rescue ArgumentError, NoMethodError
      date_value
    end
  end

  def tbc_class apply_class
    " class='emphasis-text'" if apply_class
  end

  def apply_outer_markup rows_markup
    "<p class='section-header'>Dates</p>"\
    "<table class='dates-table'>"\
      "#{rows_markup}"\
    "</table>"
  end

  def compile_markup dates
    apply_outer_markup dates.map  { |d| "<tr>"\
                                          "<td class='description-text'>#{d[0]}</td>"\
                                          "<td#{tbc_class(d[2])}>#{format(d[1])}</td>"\
                                        "</tr>"
                                  }.join('')
  end

  def create_dates_markup p
    dates_tbc_note = ": #{p.dates_tbc_note}" if p.dates_tbc_note && dates_single_date_tbc(p)
    dates_tbc_markup = "<tr><td class='emphasis-text'>TBC#{dates_tbc_note}</td></tr>" if dates_single_date_tbc(p)
    return apply_outer_markup(dates_tbc_markup) if dates_tbc(p) || single_date_tbc(p)

    booking_until = ' (booking until)' if booking_until(p) && single_date(p)
    return compile_markup([["Performs#{booking_until}:", p.first_date, booking_until(p)]]) if single_date(p)

    dates = []
    dates << get_first_date(p)
    dates << get_press_date(p) if p.press_date || p.press_date_tbc
    dates << get_last_date(p) unless single_date(p)

    dates_note = p.dates_note.present? ? "<p class='note-text emphasis-text'>#{p.dates_note}</p>" : ''

    compile_markup(dates.compact) + dates_note
  end

end
