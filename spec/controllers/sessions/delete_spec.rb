require 'rails_helper'

describe SessionsController, type: :controller do
  let(:super_admin_user) { create :super_admin_user }
  let(:admin_user) { create :admin_user }
  let(:user) { create :user }

  context 'attempt destroy session (log out) having logged in' do
    it 'by logging out (as different user types): redirect to home page' do
      [
        { user: super_admin_user, type: 'super_admin_user' },
        { user: admin_user, type: 'admin_user' },
        { user: user, type: 'user' }
      ].each do |u|
        session[:user_id] = u[:user].id
        delete :destroy
        expect(session[:user_id]).to eq nil
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end
end
