require 'rails_helper'

describe Production, type: :model do
  context 'associations' do
    it { should belong_to :creator }
    it { should belong_to :updater }
  end

  let(:production) { build :production }

  context 'valid details' do
    it 'should be valid' do
      expect(production.valid?).to be true
    end
  end

  context 'title validation' do
    it 'should not be valid if name not present' do
      production.title = ' '
      expect(production.valid?).to be false
    end

    it 'should not be valid if title too long' do
      production.title = 'a' * 256
      expect(production.valid?).to be false
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
  end
end
