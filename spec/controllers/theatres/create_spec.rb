require 'rails_helper'

describe TheatresController, type: :controller do
  context 'attempt create theatre' do
    it 'is not routable (created via production create/update)' do
      expect(post: '/theatres').not_to be_routable
    end
  end
end
