require 'rails_helper'

describe Production, type: :model do
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
end
