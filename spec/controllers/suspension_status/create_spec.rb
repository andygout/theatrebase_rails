require 'rails_helper'

describe SuspensionStatusController, type: :controller do
  context 'attempt create suspension status' do
    it 'is not routable (created via user update)' do
      expect(post: '/suspension_status').not_to be_routable
    end
  end
end
