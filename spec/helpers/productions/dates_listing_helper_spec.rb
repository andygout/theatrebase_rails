require 'rails_helper'

describe Productions::DatesListingHelper, type: :helper do
  let(:production) { create :production }

  context 'outputting dates markup (for production listings)' do
    it 'same dates for first and last performance (i.e. performs for one day only)' do
      production.last_date = '05/08/2015'
      expect(listing_dates(production)).to eq "<span>05 Aug 2015 only</span>"
    end

    it 'same dates for first and last performance (i.e. performs for one day only); "booking until" set' do
      production.last_date = '05/08/2015'
      production.dates_info = 1
      expect(listing_dates(production)).to eq "<span class='emphasis-text'>05 Aug 2015 only</span>"
    end

    it 'same dates for first and last performance (i.e. performs for one day only); "last date TBC" set' do
      production.last_date = '05/08/2015'
      production.dates_info = 2
      expect(listing_dates(production)).to eq "<span class='emphasis-text'>Dates TBC</span>"
    end

    it 'different dates for first and last performance' do
      expect(listing_dates(production)).to eq "<span>05 Aug 2015</span> - <span>31 Oct 2015</span>"
    end

    it 'different dates for first and last performance; "booking until" set' do
      production.dates_info = 1
      expect(listing_dates(production)).to eq "<span>05 Aug 2015</span> - <span class='emphasis-text'>31 Oct 2015</span>"
    end

    it 'different dates for first and last performance; "last date TBC" set' do
      production.dates_info = 2
      expect(listing_dates(production)).to eq "<span>05 Aug 2015</span> - <span class='emphasis-text'>TBC</span>"
    end

    it 'dates are TBC' do
      production.dates_info = 3
      expect(listing_dates(production)).to eq "<span class='emphasis-text'>Dates TBC</span>"
    end

    it 'dates are TBC; "dates TBC note" given' do
      production.dates_info = 3
      production.dates_tbc_note = 'Summer 2015'
      expect(listing_dates(production)).to eq "<span class='emphasis-text'>Summer 2015</span>"
    end
  end
end
