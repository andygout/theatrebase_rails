require 'rails_helper'

describe Suspension, type: :model do
  context 'associations' do
    it { should belong_to :user }
    it { should belong_to :assignor }
  end

  let(:suspended_user) { create :suspended_user }

  context 'valid details' do
    it 'should be valid' do
      expect(suspended_user.suspension.valid?).to be true
    end
  end

  context 'associations validation' do
    it 'invalid if user not present' do
      suspended_user.suspension.user = nil
      expect(suspended_user.suspension.valid?).to be false
    end

    it 'invalid if assignor not present' do
      suspended_user.suspension.assignor = nil
      expect(suspended_user.suspension.valid?).to be false
    end
  end
end
