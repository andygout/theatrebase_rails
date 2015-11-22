require 'rails_helper'

describe SessionsController, type: :controller do
  context 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
end
