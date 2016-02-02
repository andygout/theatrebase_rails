require 'rails_helper'

describe Suspension, type: :model do
  context 'associations' do
    it { should belong_to :user }
    it { should belong_to :assignor }
  end
end
