require 'rails_helper'

describe SuperAdmin, type: :model do
  context 'relations' do
    it { should belong_to :user }
  end
end
