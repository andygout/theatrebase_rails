module Productions::DatesTableHelper

  include Productions::DatesHelper
  include Shared::MarkupHelper

  def single_date_tbc? p
    single_date?(p) && last_date_tbc?(p)
  end

  def dates_single_date_tbc? p
    dates_tbc?(p) || single_date_tbc?(p)
  end

  def opening_first_date? p
    p.first_date == p.press_date
  end

  def get_first_date p
    wording = p.press_date ?
      !opening_first_date?(p) ? 'First preview:' : 'Opening performance:' :
      p.press_date_tbc ? 'First preview:' : 'First performance:'
    [{ content: wording }, { content: date_table_format(p.first_date) }]
  end

  def get_press_date p
    date_value = !p.second_press_date ?
      date_table_format(p.press_date) :
      "#{date_table_format(p.press_date)} and #{date_table_format(p.second_press_date)}"

    wording = !p.press_date_wording.present? ?
      "Press performance#{:s if p.second_press_date}:" :
      "#{p.press_date_wording}:"

    !p.press_date_tbc ?
      opening_first_date?(p) ? nil : [{ content: wording }, { content: date_value }] :
      [{ content: wording }, { content: 'TBC', class: 'emphasis-text' }]
  end

  def get_last_date p
    return [
        { content: 'Booking until:' }, { content: date_table_format(p.last_date), class: 'emphasis-text' }
      ] if booking_until?(p)
    return [
        { content: 'Last performance:' }, { content: 'TBC', class: 'emphasis-text' }
      ] if last_date_tbc?(p)
    [{ content: 'Last performance:' }, { content: date_table_format(p.last_date) }]
  end

  def dates_table p
    if dates_single_date_tbc?(p)
      dates_tbc_note = ": #{p.dates_tbc_note}" if p.dates_tbc_note && dates_single_date_tbc?(p)
      dates_tbc_row = "<tr><td class='emphasis-text'>TBC#{dates_tbc_note}</td></tr>" if dates_single_date_tbc?(p)
      return bookend_tags('table', dates_tbc_row, 'dates-tbc-table')
    end

    if single_date?(p)
      booking_until_text = ' (booking until)' if booking_until?(p)
      booking_until_class = booking_until?(p) ? 'emphasis-text' : nil
      row_values = [[
          { content: "Performs#{booking_until_text}:" },
          { content: date_table_format(p.first_date), class: booking_until_class }
        ]]
      return bookend_tags('table', compile_rows(row_values), 'dates-table')
    end

    dates = []
    dates << get_first_date(p)
    dates << get_press_date(p) if p.press_date || p.press_date_tbc
    dates << get_last_date(p) unless single_date?(p)
    bookend_tags('table', compile_rows(dates.compact), 'dates-table')
  end

  def get_dates p
    dates_note = p.dates_note.present? ? "<p class='note-text emphasis-text'>#{p.dates_note}</p>" : ''
    dates_markup = "<p class='content-label'>Dates</p>" + dates_table(p) + dates_note
    @dates = dates_markup.html_safe
  end

end
