require 'rails_helper'

include Shared::ConstantsHelper

describe Theatre, type: :model do
  context 'associations' do
    it { should have_many :productions }
    it { should belong_to :creator }
    it { should belong_to :updater }
  end

  let(:theatre) { build :theatre }

  context 'valid details' do
    it 'should be valid' do
      expect(theatre.valid?).to be true
    end
  end

  context 'name validation' do
    it 'invalid if name not present' do
      theatre.name = ' '
      expect(theatre.valid?).to be false
    end

    it 'invalid if name exceeds length limit' do
      theatre.name = 'a' * (TEXT_MAX_LENGTH + 1)
      expect(theatre.valid?).to be false
    end

    it 'valid if name present and does not exceed length limit' do
      theatre.name = 'a' * TEXT_MAX_LENGTH
      expect(theatre.valid?).to be true
    end
  end
end
