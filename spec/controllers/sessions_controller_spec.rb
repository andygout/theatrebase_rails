require 'rails_helper'

describe SessionsController, type: :controller do
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }

  context 'attempt new session' do
    it 'returns http success; renders new session form (log in page)' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  context 'attempt create session (log in) when account suspended' do
    it 'by logging in (as different suspended user types): fail and redirect to home page' do
      [
        {user: suspended_super_admin_user, type: 'suspended_super_admin_user'},
        {user: suspended_admin_user, type: 'suspended_admin_user'},
        {user: suspended_user, type: 'suspended_user'}
      ].each do |u|
        post :create, session: { email: u[:user].email, password: u[:user].password }
        expect(session[:user_id]).to eq nil
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end
end
