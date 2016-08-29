require 'rails_helper'

describe AdminStatusController, type: :controller do
  context 'attempt create admin status' do
    it 'is not routable (created via user update)' do
      expect(post: '/admin_status').not_to be_routable
    end
  end
end
