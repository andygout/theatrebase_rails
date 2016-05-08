module Productions::DatesHelper

  def booking_until? p
    p.dates_info == 1
  end

  def last_date_tbc? p
    p.dates_info == 2
  end

  def dates_tbc? p
    p.dates_info == 3
  end

  def single_date? p
    p.press_date ?
      [p.first_date, p.press_date, p.last_date].uniq.count == 1 :
      p.first_date == p.last_date
  end

  def date_string date_value, format
    begin
      date_value.strftime(format) if Date.parse(date_value.to_s)
    rescue ArgumentError, NoMethodError
      date_value
    end
  end

  def date_table_format date_value
    date_string(date_value, '%a, %d %b %Y')
  end

  def date_listing_format date_value
    date_string(date_value, '%d %b %Y')
  end

end
