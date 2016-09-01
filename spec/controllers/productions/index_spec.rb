require 'rails_helper'

describe ProductionsController, type: :controller do
  let(:user) { create :user }
  let(:admin_user) { create :admin_user }
  let(:super_admin_user) { create :super_admin_user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }

  context 'attempt view production index' do
    it 'as super-admin: render production display page' do
      session[:user_id] = super_admin_user.id
      get :index
      expect(response).to render_template :index
    end

    it 'as admin: render production display page' do
      session[:user_id] = admin_user.id
      get :index
      expect(response).to render_template :index
    end

    it 'as non-admin: render production display page' do
      session[:user_id] = user.id
      get :index
      expect(response).to render_template :index
    end

    it 'as suspended super-admin: render production display page' do
      session[:user_id] = suspended_super_admin_user.id
      get :index
      expect(response).to render_template :index
    end

    it 'as suspended admin: render production display page' do
      session[:user_id] = suspended_admin_user.id
      get :index
      expect(response).to render_template :index
    end

    it 'as suspended non-admin: render production display page' do
      session[:user_id] = suspended_user.id
      get :index
      expect(response).to render_template :index
    end

    it 'when not logged in: render production index' do
      get :index
      expect(response).to render_template :index
    end
  end
end
