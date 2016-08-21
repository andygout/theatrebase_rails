require 'rails_helper'

describe Productions::DatesTableHelper, type: :helper do
  let(:production) { create :production }

  context 'outputting dates markup' do
    it 'first and last performance only; same dates (i.e. performs for one day only)' do
      production.last_date = '05/08/2015'
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>Performs:</td><td>Wed, 05 Aug 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first and last performance only; same dates (i.e. performs for one day only); "booking until" set' do
      production.last_date = '05/08/2015'
      production.dates_info = 1
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>Performs (booking until):</td><td class='emphasis-text'>Wed, 05 Aug 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first and last performance only; same dates (i.e. performs for one day only); "last date TBC" set' do
      production.last_date = '05/08/2015'
      production.dates_info = 2
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-tbc-table'>"\
            "<tr><td class='emphasis-text'>TBC</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first and last performance only; different dates for each' do
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>First performance:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Last performance:</td><td>Sat, 31 Oct 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first and last performance only; different dates for each; "press date TBC" set' do
      production.press_date_tbc = true
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>First preview:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Press performance:</td><td class='emphasis-text'>TBC</td></tr>"\
            "<tr><td>Last performance:</td><td>Sat, 31 Oct 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first and last performance only; different dates for each; "booking until" set' do
      production.dates_info = 1
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>First performance:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Booking until:</td><td class='emphasis-text'>Sat, 31 Oct 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first and last performance only; different dates for each; "last date TBC" set' do
      production.dates_info = 2
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>First performance:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Last performance:</td><td class='emphasis-text'>TBC</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first, press and last performance; different dates for each' do
      production.press_date = '25/08/2015'
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>First preview:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Press performance:</td><td>Tue, 25 Aug 2015</td></tr>"\
            "<tr><td>Last performance:</td><td>Sat, 31 Oct 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first, press and last performance; first and press performance match' do
      production.press_date = '05/08/2015'
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>Opening performance:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Last performance:</td><td>Sat, 31 Oct 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first, press and last performance; all dates match (i.e. performs for one day only)' do
      production.press_date = '05/08/2015'
      production.last_date = '05/08/2015'
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>Performs:</td><td>Wed, 05 Aug 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first, press and last performance; different dates for each; "booking until" set' do
      production.press_date = '25/08/2015'
      production.dates_info = 1
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>First preview:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Press performance:</td><td>Tue, 25 Aug 2015</td></tr>"\
            "<tr><td>Booking until:</td><td class='emphasis-text'>Sat, 31 Oct 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first, press and last performance; different dates for each; "last date TBC" set' do
      production.press_date = '25/08/2015'
      production.dates_info = 2
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>First preview:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Press performance:</td><td>Tue, 25 Aug 2015</td></tr>"\
            "<tr><td>Last performance:</td><td class='emphasis-text'>TBC</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first, press and last performance; different dates for each; "press date wording" given' do
      production.press_date = '25/08/2015'
      production.press_date_wording = 'Gala night'
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>First preview:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Gala night:</td><td>Tue, 25 Aug 2015</td></tr>"\
            "<tr><td>Last performance:</td><td>Sat, 31 Oct 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first and last performance only; different dates for each; "press date TBC" set; "press date wording" given' do
      production.press_date_tbc = true
      production.press_date_wording = 'Gala night'
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>First preview:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Gala night:</td><td class='emphasis-text'>TBC</td></tr>"\
            "<tr><td>Last performance:</td><td>Sat, 31 Oct 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'dates are TBC' do
      production.dates_info = 3
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-tbc-table'>"\
            "<tr><td class='emphasis-text'>TBC</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'dates are TBC; "dates TBC note" given' do
      production.dates_info = 3
      production.dates_tbc_note = 'Summer 2015'
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-tbc-table'>"\
            "<tr><td class='emphasis-text'>TBC: Summer 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'first, press, second press and last performance; different dates for each' do
      production.press_date = '25/08/2015'
      production.second_press_date = '26/08/2015'
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>First preview:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Press performances:</td><td>Tue, 25 Aug 2015 and Wed, 26 Aug 2015</td></tr>"\
            "<tr><td>Last performance:</td><td>Sat, 31 Oct 2015</td></tr>"\
          "</table>"\
        "</div>"
    end

    it 'accompanying "dates note" given' do
      production.dates_note = 'Press night postponed'
      expect(get_dates_markup(production)).to eq \
        "<div id='dates' class='content-wrapper'>"\
          "<div class='content-label'>Dates</div>"\
          "<table class='table dates-table'>"\
            "<tr><td>First performance:</td><td>Wed, 05 Aug 2015</td></tr>"\
            "<tr><td>Last performance:</td><td>Sat, 31 Oct 2015</td></tr>"\
          "</table>"\
          "<p class='note-text emphasis-text'>Press night postponed</p>"\
        "</div>"
    end
  end
end
