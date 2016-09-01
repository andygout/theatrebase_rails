require 'rails_helper'

describe UsersController, type: :controller do
  let(:super_admin_user) { create :super_admin_user }
  let(:admin_user) { create :admin_user }
  let(:user) { create :user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }

  context 'attempt view user index' do
    it 'as super-admin user: render user index' do
      session[:user_id] = super_admin_user.id
      get :index
      expect(response).to render_template :index
    end

    it 'as admin user: render user index' do
      session[:user_id] = admin_user.id
      get :index
      expect(response).to render_template :index
    end

    it 'as non-admin user: fail and redirect to home page' do
      session[:user_id] = user.id
      get :index
      expect(response).to redirect_to root_path
    end

    it 'as suspended super-admin user: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      get :index
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin user: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      get :index
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin user: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      get :index
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :index
      expect(response).to redirect_to log_in_path
    end
  end
end
