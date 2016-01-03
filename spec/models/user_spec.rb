require 'rails_helper'

describe User, type: :model do
  context 'relations' do
    it { should have_one :admin }
    it { should have_one :super_admin }
    it { should belong_to :creator }
    it { should have_many :created_users }
    it { should belong_to :updater }
    it { should have_many :updated_users }
  end

  let(:user) { build :user }

  context 'valid details' do
    it 'should be valid' do
      expect(user.valid?).to be true
    end
  end

  context 'name validation' do
    it 'should not be valid if name not present' do
      user.name = ' '
      expect(user.valid?).to be false
    end

    it 'should not be valid if name too long' do
      user.name = 'a' * 256
      expect(user.valid?).to be false
    end
  end

  context 'email validation' do
    it 'should not be valid if email not present' do
      user.email = ' '
      expect(user.valid?).to be false
    end

    it 'should not be valid if email too long' do
      user.email = 'a' * 244 + '@example.com'
      expect(user.valid?).to be false
    end

    it 'should be valid if correct format' do
      valid_addresses = ['user@example.com', 'USER@foo.COM', 'A_US-ER@foo.bar.org', 'first.last@foo.jp', 'alice+bob@baz.cn']
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user.valid?).to be(true), "#{valid_address.inspect} should be valid"
      end
    end

    it 'should be invalid if incorrect format' do
      invalid_addresses = ['user@example,com', 'user_at_foo.org', 'user.name@example.', 'foor@bar_baz.com', 'foo@bar+baz.com', 'foo@bar..com']
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user.valid?).to be(false), "#{invalid_address.inspect} should be invalid"
      end
    end

    it 'should be invalid if not unique' do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save
      expect(duplicate_user.valid?).to be false
    end

    it 'should be saved as lowercase' do
      mixed_case_email = 'Foo@ExAMPle.CoM'
      user.email = mixed_case_email
      user.save
      expect(mixed_case_email.downcase).to eq user.reload.email
    end
  end

  context 'password validation' do
    it 'should not be valid if less than minimum length' do
      user.password = user.password_confirmation = 'a' * 5
      expect(user.valid?).to be false
    end

    it 'should not be valid if comprised solely of blank spaces' do
      user.password = user.password_confirmation = ' ' * 6
      expect(user.valid?).to be false
    end

    it 'should not be valid if too long' do
      user.password = user.password_confirmation = 'a' * 73
      expect(user.valid?).to be false
    end
  end

  context 'authentication' do
    it 'should return false for a user with nil digest' do
      expect(user.authenticated?(:remember, '')).to be false
    end
  end
end
