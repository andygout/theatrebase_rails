require 'rails_helper'

describe Production, type: :model do
  context 'associations' do
    it { should belong_to :creator }
    it { should belong_to :updater }
  end

  let(:production) { build :production }
  LENGTH_LIMIT = 255

  context 'valid details' do
    it 'should be valid' do
      expect(production.valid?).to be true
    end
  end

  context 'title validation' do
    it 'invalid if name not present' do
      production.title = ' '
      expect(production.valid?).to be false
    end

    it 'invalid if title exceeds length limit' do
      production.title = 'a' * (LENGTH_LIMIT + 1)
      expect(production.valid?).to be false
    end

    it 'valid if title present and does not exceed length limit' do
      production.title = 'a' * LENGTH_LIMIT
      expect(production.valid?).to be true
    end
  end

  context 'first and last dates validation' do
    it 'invalid if first date not given' do
      production.first_date = nil
      expect(production.valid?).to be false
    end

    it 'invalid if last date not given' do
      production.last_date = nil
      expect(production.valid?).to be false
    end

    it 'invalid if first date is later than last date' do
      production.first_date = '31/10/2015'
      production.last_date = '05/08/2015'
      expect(production.valid?).to be false
    end

    it 'valid if first date is earlier than last date' do
      production.first_date = '05/08/2015'
      production.last_date = '31/10/2015'
      expect(production.valid?).to be true
    end

    it 'valid if first and last dates are equal' do
      production.first_date = '05/08/2015'
      production.last_date = '05/08/2015'
      expect(production.valid?).to be true
    end
  end

  context 'press date validation' do
    it 'invalid if date not given in correct format' do
      production.press_date = 'The twenty-fifth day of August in the year two-thousand and fifteen'
      expect(production.valid?).to be false
    end

    it 'invalid if earlier than first date' do
      production.press_date = '04/08/2015'
      expect(production.valid?).to be false
    end

    it 'invalid if later than last date' do
      production.press_date = '01/11/2015'
      expect(production.valid?).to be false
    end

    it 'valid if later than first date and earlier than last date' do
      production.press_date = '25/08/2015'
      expect(production.valid?).to be true
    end

    it 'valid if equal to first date' do
      production.press_date = '05/08/2015'
      expect(production.valid?).to be true
    end

    it 'valid if equal to last date' do
      production.press_date = '31/10/2015'
      expect(production.valid?).to be true
    end

    it 'invalid if press date given and "press date TBC" checked' do
      production.press_date = '25/08/2015'
      production.press_date_tbc = true
      expect(production.valid?).to be false
    end

    it 'valid if no press date given and "press date TBC" checked' do
      production.press_date_tbc = true
      expect(production.valid?).to be true
    end

    it 'invalid if press date given and "previews only" checked' do
      production.press_date = '25/08/2015'
      production.previews_only = true
      expect(production.valid?).to be false
    end

    it 'valid if no press date given and "previews only" checked' do
      production.previews_only = true
      expect(production.valid?).to be true
    end
  end

  context 'date text fields validation' do
    it 'invalid if "press date wording" exceeds length limit' do
      production.press_date_wording = 'a' * (LENGTH_LIMIT + 1)
      expect(production.valid?).to be false
    end

    it 'valid if "press date wording" does not exceed length limit' do
      production.press_date_wording = 'a' * LENGTH_LIMIT
      expect(production.valid?).to be true
    end

    it 'invalid if "dates TBC note" exceeds length limit' do
      production.dates_tbc_note = 'a' * (LENGTH_LIMIT + 1)
      expect(production.valid?).to be false
    end

    it 'valid if "dates TBC note" does not exceed length limit' do
      production.dates_tbc_note = 'a' * LENGTH_LIMIT
      expect(production.valid?).to be true
    end

    it 'invalid if "dates note" exceeds length limit' do
      production.dates_note = 'a' * (LENGTH_LIMIT + 1)
      expect(production.valid?).to be false
    end

    it 'valid if "dates note" does not exceed length limit' do
      production.dates_note = 'a' * LENGTH_LIMIT
      expect(production.valid?).to be true
    end
  end

  context 'second press date validation' do
    it 'invalid if second press date given without press date' do
      production.second_press_date = '26/08/2015'
      expect(production.valid?).to be false
    end

    it 'invalid if date not given in correct format (but press date given)' do
      production.press_date = '25/08/2015'
      production.second_press_date = 'The twenty-sixth day of August in the year two-thousand and fifteen'
      expect(production.valid?).to be false
    end

    it 'invalid if second press date before press date' do
      production.press_date = '25/08/2015'
      production.second_press_date = '24/08/2015'
      expect(production.valid?).to be false
    end

    it 'invalid if second press date equal to press date' do
      production.press_date = '25/08/2015'
      production.second_press_date = '25/08/2015'
      expect(production.valid?).to be false
    end

    it 'invalid if second press date after last date' do
      production.press_date = '25/08/2015'
      production.second_press_date = '01/11/2015'
      expect(production.valid?).to be false
    end

    it 'valid if second press date after press date and before last date' do
      production.press_date = '25/08/2015'
      production.second_press_date = '26/08/2015'
      expect(production.valid?).to be true
    end

    it 'valid if second press date after press date and equal to last date' do
      production.press_date = '25/08/2015'
      production.second_press_date = '31/10/2015'
      expect(production.valid?).to be true
    end
  end
end
