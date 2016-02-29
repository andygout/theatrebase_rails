module ProductionsShowHelper

  def format date
    date.strftime('%a, %d %b %Y')
  end

  def compile_markup dates
    dates.map { |d| '<tr><td>' + d[0] + '</td><td>' + format(d[1]) + '</td></tr>' }.join('')
  end

  def create_dates_markup production
    dates = []
    dates << ['First performance:', production.first_date]
    dates << ['Press performance:', production.press_date] if production.press_date
    dates << ['Last performance:', production.last_date]
    compile_markup(dates)
  end

end
