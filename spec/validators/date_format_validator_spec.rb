require 'rails_helper'

describe DateFormatValidator, type: :validator do
  context 'date format validation' do
    with_model :production do
      table { |t| t.date :press_date }
      model { validates :press_date, date_format: true }
    end

    it 'valid if date is valid date' do
      expect(Production.new(press_date: '25/08/2015').valid?).to be true
    end

    it 'does not invalidate production if date is not given a value' do
      expect(Production.new(press_date: nil).valid?).to be true
    end

    it 'invalid if date is an unaccepted string value' do
      expect(Production.new(press_date: 'foobar').valid?).to be false
    end

    it 'invalid if date is an (inexplicably) accepted string value but its original value is blank' do
      expect(Production.new(press_date: 'monkey').valid?).to be false
    end
  end
end
