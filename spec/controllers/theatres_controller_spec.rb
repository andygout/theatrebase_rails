require 'rails_helper'

describe TheatresController, type: :controller do
  let(:user) { create :user }
  let(:admin_user) { create :admin_user }
  let(:super_admin_user) { create :super_admin_user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let(:add_theatre) { attributes_for :add_theatre }
  let!(:theatre) { create :theatre }

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

  context 'attempt update theatre' do
    it 'as super-admin: succeed and redirect to theatre display page' do
      session[:user_id] = super_admin_user.id
      patch :update, url: theatre.url, theatre: { name: add_theatre[:name] }
      expect(add_theatre[:name]).to eq theatre.reload.name
      expect(response).to redirect_to theatre_path(theatre.url)
    end

    it 'as admin: succeed and redirect to theatre display page' do
      session[:user_id] = admin_user.id
      patch :update, url: theatre.url, theatre: { name: add_theatre[:name] }
      expect(add_theatre[:name]).to eq theatre.reload.name
      expect(response).to redirect_to theatre_path(theatre.url)
    end

    it 'as non-admin: succeed and redirect to theatre display page' do
      session[:user_id] = user.id
      patch :update, url: theatre.url, theatre: { name: add_theatre[:name] }
      expect(add_theatre[:name]).to eq theatre.reload.name
      expect(response).to redirect_to theatre_path(theatre.url)
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      patch :update, url: theatre.url, theatre: { name: add_theatre[:name] }
      expect(theatre.name).to eq theatre.reload.name
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      patch :update, url: theatre.url, theatre: { name: add_theatre[:name] }
      expect(theatre.name).to eq theatre.reload.name
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      patch :update, url: theatre.url, theatre: { name: add_theatre[:name] }
      expect(theatre.name).to eq theatre.reload.name
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      patch :update, url: theatre.url, theatre: { name: add_theatre[:name] }
      expect(theatre.name).to eq theatre.reload.name
      expect(response).to redirect_to log_in_path
    end

    it 'permitted update will remove leading and trailing whitespace from string fields' do
      session[:user_id] = user.id
      patch :update, url: theatre.url, theatre: { name: ' ' + add_theatre[:name] + ' ' }
      theatre.reload
      expect(theatre.name).to eq add_theatre[:name]
    end
  end

  context 'attempt delete theatre' do
    it 'as super-admin: succeed and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { delete :destroy, url: theatre.url }.to change { Theatre.count }.by -1
      expect(response).to redirect_to root_path
    end

    it 'as admin: succeed and redirect to home page' do
      session[:user_id] = admin_user.id
      expect { delete :destroy, url: theatre.url }.to change { Theatre.count }.by -1
      expect(response).to redirect_to root_path
    end

    it 'as non-admin: succeed and redirect to home page' do
      session[:user_id] = user.id
      expect { delete :destroy, url: theatre.url }.to change { Theatre.count }.by -1
      expect(response).to redirect_to root_path
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      expect { delete :destroy, url: theatre.url }.to change { Theatre.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      expect { delete :destroy, url: theatre.url }.to change { Theatre.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      expect { delete :destroy, url: theatre.url }.to change { Theatre.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { delete :destroy, url: theatre.url }.to change { Theatre.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt show theatre display page' do
    it 'as super-admin: render theatre display page' do
      session[:user_id] = super_admin_user.id
      get :show, url: theatre.url
      expect(response).to render_template :show
    end

    it 'as admin: render theatre display page' do
      session[:user_id] = admin_user.id
      get :show, url: theatre.url
      expect(response).to render_template :show
    end

    it 'as non-admin: render theatre display page' do
      session[:user_id] = user.id
      get :show, url: theatre.url
      expect(response).to render_template :show
    end

    it 'as suspended super-admin: render theatre display page' do
      session[:user_id] = suspended_super_admin_user.id
      get :show, url: theatre.url
      expect(response).to render_template :show
    end

    it 'as suspended admin: render theatre display page' do
      session[:user_id] = suspended_admin_user.id
      get :show, url: theatre.url
      expect(response).to render_template :show
    end

    it 'as suspended non-admin: render theatre display page' do
      session[:user_id] = suspended_user.id
      get :show, url: theatre.url
      expect(response).to render_template :show
    end

    it 'when not logged in: render theatre display page' do
      get :show, url: theatre.url
      expect(response).to render_template :show
    end
  end
end
