require 'rails_helper'

describe User, type: :model do
  context 'associations' do
    it { should have_one :admin }
    it { should have_one(:admin_status_assignor).through(:admin) }
    it { should have_many :admins }
    it { should have_many(:admin_status_assignees).through(:admins) }
    it { should have_one :super_admin }
    it { should have_one :suspension }
    it { should have_one(:suspension_status_assignor).through(:suspension) }
    it { should have_many :suspensions }
    it { should have_many(:suspension_status_assignees).through(:suspensions) }
    it { should belong_to :creator }
    it { should have_many :created_users }
    it { should belong_to :updater }
    it { should have_many :updated_users }
    it { should have_many :created_productions }
    it { should have_many :updated_productions }
  end

  let(:user) { build :user }
  TEXT_MAX_LENGTH = 255
  PASSWORD_MIN_LENGTH = 6
  PASSWORD_MAX_LENGTH = 255

  context 'valid details' do
    it 'should be valid' do
      expect(user.valid?).to be true
    end
  end

  context 'name validation' do
    it 'invalid if name not present' do
      user.name = ' '
      expect(user.valid?).to be false
    end

    it 'invalid if name exceeds length limit' do
      user.name = 'a' * (TEXT_MAX_LENGTH + 1)
      expect(user.valid?).to be false
    end
  end

  context 'email validation' do
    it 'invalid if email not present' do
      user.email = ' '
      expect(user.valid?).to be false
    end

    it 'invalid if email exceeds length limit' do
      user.email = 'a' * (TEXT_MAX_LENGTH - 11) + '@example.com'
      expect(user.valid?).to be false
    end

    it 'valid if correct format' do
      valid_addresses = ['user@example.com', 'USER@foo.COM', 'A_US-ER@foo.bar.org', 'first.last@foo.jp', 'alice+bob@baz.cn']
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user.valid?).to be(true), "#{valid_address.inspect} should be valid"
      end
    end

    it 'invalid if incorrect format' do
      invalid_addresses = ['user@example,com', 'user_at_foo.org', 'user.name@example.', 'foor@bar_baz.com', 'foo@bar+baz.com', 'foo@bar..com']
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user.valid?).to be(false), "#{invalid_address.inspect} should be invalid"
      end
    end

    it 'invalid if not unique' do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save
      expect(duplicate_user.valid?).to be false
    end

    it 'saved as lowercase' do
      mixed_case_email = 'Foo@ExAMPle.CoM'
      user.email = mixed_case_email
      user.save
      expect(mixed_case_email.downcase).to eq user.reload.email
    end
  end

  context 'password validation' do
    it 'invalid if less than minimum length' do
      user.password = user.password_confirmation = 'a' * (PASSWORD_MIN_LENGTH - 1)
      expect(user.valid?).to be false
    end

    it 'invalid if comprised solely of blank spaces' do
      user.password = user.password_confirmation = ' ' * PASSWORD_MIN_LENGTH
      expect(user.valid?).to be false
    end

    it 'invalid if exceeds length limit' do
      user.password = user.password_confirmation = 'a' * (PASSWORD_MAX_LENGTH + 1)
      expect(user.valid?).to be false
    end

    it 'invalid if password and confirmation do not match' do
      user.password = 'foobar'
      user.password_confirmation = 'barfoo'
      expect(user.valid?).to be false
    end

    it 'valid if password and confirmation match and meet criteria' do
      user.password = 'foobar'
      user.password_confirmation = 'foobar'
      expect(user.valid?).to be true
    end
  end

  context 'authentication' do
    it 'return false for a user with nil digest' do
      expect(user.authenticated?(:remember, '')).to be false
    end
  end
end
