require 'rails_helper'

describe SessionsController, type: :controller do
  context 'attempt new session' do
    it 'returns http success; renders new session form (log in page)' do
      get :new
      expect(response).to have_http_status :success
      expect(response).to render_template :new
    end
  end
end
