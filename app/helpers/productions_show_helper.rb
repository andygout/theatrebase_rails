module ProductionsShowHelper

  def create_dates_markup production
    dates = "<tr><td>First performance:</td>"
    dates << "<td>" + production.first_date.strftime('%a, %d %b %Y') + "</td></tr>"
    dates << "<tr><td>Press performance:</td>" if @production.press_date
    dates << "<td>" + production.press_date.strftime('%a, %d %b %Y') + "</td></tr>" if @production.press_date
    dates << "<tr><td>Last performance:</td>"
    dates << "<td>" + production.last_date.strftime('%a, %d %b %Y') + "</td></tr>"
  end

end
