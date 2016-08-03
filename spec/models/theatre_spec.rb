require 'rails_helper'

describe Theatre, type: :model do
  context 'associations' do
    it { should have_many :productions }
    it { should belong_to :creator }
    it { should belong_to :updater }
  end
end
