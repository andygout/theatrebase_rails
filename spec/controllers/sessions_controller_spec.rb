require 'rails_helper'

describe SessionsController, type: :controller do
  let(:super_admin_user) { create :super_admin_user }
  let(:admin_user) { create :admin_user }
  let(:user) { create :user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }

  context 'attempt new session' do
    it 'returns http success; renders new session form (log in page)' do
      get :new
      expect(response).to have_http_status :success
      expect(response).to render_template :new
    end
  end

  context 'attempt create session (log in)' do
    it 'by logging in (as different user types): redirect to user display page' do
      [
          {user: super_admin_user, type: 'super_admin_user'},
          {user: admin_user, type: 'admin_user'},
          {user: user, type: 'user'}
      ].each do |u|
        post :create, session: { email: u[:user].email, password: u[:user].password }
        expect(session[:user_id]).to eq u[:user].id
        expect(response).to redirect_to(u[:user]), "Failed: #{u[:type]}"
      end
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

  context 'attempt destroy session (log out) having logged in' do
    it 'by logging out (as different user types): redirect to home page' do
      [
        {user: super_admin_user, type: 'super_admin_user'},
        {user: admin_user, type: 'admin_user'},
        {user: user, type: 'user'}
      ].each do |u|
        session[:user_id] = u[:user].id
        delete :destroy
        expect(session[:user_id]).to eq nil
        expect(response).to redirect_to(root_path), "Failed: #{u[:type]}"
      end
    end
  end
end
