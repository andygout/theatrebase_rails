require 'rails_helper'

describe User, type: :model do
  let(:user) { User.new name: 'Andy Gout', email: 'andygout@example.com' }

  it 'should be valid' do
    expect(user.valid?).to be true
  end
end