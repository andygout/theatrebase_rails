require 'rails_helper'

describe Admin, type: :model do
  context 'associations' do
    it { should belong_to :user }
    it { should belong_to :assignor }
  end

  let(:admin_user) { create :admin_user }

  context 'valid details' do
    it 'should be valid' do
      expect(admin_user.admin.valid?).to be true
    end
  end

  context 'associations validation' do
    it 'invalid if user not present' do
      admin_user.admin.user = nil
      expect(admin_user.admin.valid?).to be false
    end

    it 'invalid if assignor not present' do
      admin_user.admin.assignor = nil
      expect(admin_user.admin.valid?).to be false
    end
  end
end
