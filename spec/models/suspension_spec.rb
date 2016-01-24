require 'rails_helper'

describe Suspension, type: :model do
  context 'relations' do
    it { should belong_to :user }
    it { should belong_to :assignor }
  end
end
