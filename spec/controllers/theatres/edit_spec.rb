require 'rails_helper'

describe TheatresController, type: :controller do
  let(:user) { create :user }
  let(:admin_user) { create :admin_user }
  let(:super_admin_user) { create :super_admin_user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let!(:production) { create :production }
  let!(:theatre) { production.theatre }

  context 'attempt edit theatre' do
    it 'as super-admin: render theatre edit form' do
      session[:user_id] = super_admin_user.id
      get :edit, url: theatre.url
      expect(response).to render_template :edit
    end

    it 'as admin: render theatre edit form' do
      session[:user_id] = admin_user.id
      get :edit, url: theatre.url
      expect(response).to render_template :edit
    end

    it 'as non-admin: render theatre edit form' do
      session[:user_id] = user.id
      get :edit, url: theatre.url
      expect(response).to render_template :edit
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      get :edit, url: theatre.url
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      get :edit, url: theatre.url
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      get :edit, url: theatre.url
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :edit, url: theatre.url
      expect(response).to redirect_to log_in_path
    end
  end
end
