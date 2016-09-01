require 'rails_helper'

describe TheatresController, type: :controller do
  context 'attempt view theatre index' do
    it 'is not routable' do
      expect(get: '/theatres').not_to be_routable
    end
  end
end
