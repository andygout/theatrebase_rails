require 'rails_helper'

describe ProductionsController, type: :controller do
  let(:user) { create :user }
  let(:admin_user) { create :admin_user }
  let(:super_admin_user) { create :super_admin_user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let(:add_production) { attributes_for :add_production }
  let!(:production) { create :production }
  let(:edit_production) { attributes_for :edit_production }

  context 'attempt add new production' do
    it 'as super-admin: render new production form' do
      session[:user_id] = super_admin_user.id
      get :new
      expect(response).to render_template :new
    end

    it 'as admin: render new production form' do
      session[:user_id] = admin_user.id
      get :new
      expect(response).to render_template :new
    end

    it 'as non-admin: render new production form' do
      session[:user_id] = user.id
      get :new
      expect(response).to render_template :new
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      get :new
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      get :new
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      get :new
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :new
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt create production' do
    let(:production_params) { { title: add_production[:title], first_date: add_production[:first_date], last_date: add_production[:last_date] } }

    it 'as super-admin: succeed and redirect to production display page' do
      session[:user_id] = super_admin_user.id
      expect { post :create, production: production_params }.to change { Production.count }.by 1
      expect(response).to redirect_to production_path(Production.last)
    end

    it 'as admin: succeed and redirect to production display page' do
      session[:user_id] = admin_user.id
      expect { post :create, production: production_params }.to change { Production.count }.by 1
      expect(response).to redirect_to production_path(Production.last)
    end

    it 'as non-admin: succeed and redirect to production display page' do
      session[:user_id] = user.id
      expect { post :create, production: production_params }.to change { Production.count }.by 1
      expect(response).to redirect_to production_path(Production.last)
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      expect { post :create, production: production_params }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      expect { post :create, production: { title: add_production[:title], first_date: add_production[:first_date], last_date: add_production[:last_date] } }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      expect { post :create, production: { title: add_production[:title], first_date: add_production[:first_date], last_date: add_production[:last_date] } }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { post :create, production: { title: add_production[:title], first_date: add_production[:first_date], last_date: add_production[:last_date] } }.to change { Production.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt edit production' do
    it 'as super-admin: redirect to production edit form' do
      session[:user_id] = super_admin_user.id
      get :edit, id: production
      expect(response).to render_template :edit
    end

    it 'as admin: redirect to production edit form' do
      session[:user_id] = admin_user.id
      get :edit, id: production
      expect(response).to render_template :edit
    end

    it 'as non-admin: redirect to production edit form' do
      session[:user_id] = user.id
      get :edit, id: production
      expect(response).to render_template :edit
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      get :edit, id: production
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      get :edit, id: production
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      get :edit, id: production
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :edit, id: production
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update production' do
    it 'as super-admin: succeed and redirect to production display page' do
      session[:user_id] = super_admin_user.id
      patch :update, id: production, production: { title: edit_production[:title] }
      expect(edit_production[:title]).to eq production.reload.title
      expect(response).to redirect_to production_path(production)
    end

    it 'as admin: succeed and redirect to production display page' do
      session[:user_id] = admin_user.id
      patch :update, id: production, production: { title: edit_production[:title] }
      expect(edit_production[:title]).to eq production.reload.title
      expect(response).to redirect_to production_path(production)
    end

    it 'as non-admin: succeed and redirect to production display page' do
      session[:user_id] = user.id
      patch :update, id: production, production: { title: edit_production[:title] }
      expect(edit_production[:title]).to eq production.reload.title
      expect(response).to redirect_to production_path(production)
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      patch :update, id: production, production: { title: edit_production[:title] }
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      patch :update, id: production, production: { title: edit_production[:title] }
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      patch :update, id: production, production: { title: edit_production[:title] }
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      patch :update, id: production, production: { title: edit_production[:title] }
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt delete production' do
    it 'as super-admin: succeed and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { delete :destroy, id: production }.to change { Production.count }.by -1
      expect(response).to redirect_to productions_path
    end

    it 'as admin: succeed and redirect to home page' do
      session[:user_id] = admin_user.id
      expect { delete :destroy, id: production }.to change { Production.count }.by -1
      expect(response).to redirect_to productions_path
    end

    it 'as non-admin: succeed and redirect to home page' do
      session[:user_id] = user.id
      expect { delete :destroy, id: production }.to change { Production.count }.by -1
      expect(response).to redirect_to productions_path
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      expect { delete :destroy, id: production }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      expect { delete :destroy, id: production }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      expect { delete :destroy, id: production }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { delete :destroy, id: production }.to change { Production.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt visit production display page' do
    it 'as super-admin: render production display page' do
      session[:user_id] = super_admin_user.id
      get :show, id: production
      expect(response).to render_template :show
    end

    it 'as admin: render production display page' do
      session[:user_id] = admin_user.id
      get :show, id: production
      expect(response).to render_template :show
    end

    it 'as non-admin: render production display page' do
      session[:user_id] = user.id
      get :show, id: production
      expect(response).to render_template :show
    end

    it 'as suspended super-admin: render production display page' do
      session[:user_id] = suspended_super_admin_user.id
      get :show, id: production
      expect(response).to render_template :show
    end

    it 'as suspended admin: render production display page' do
      session[:user_id] = suspended_admin_user.id
      get :show, id: production
      expect(response).to render_template :show
    end

    it 'as suspended non-admin: render production display page' do
      session[:user_id] = suspended_user.id
      get :show, id: production
      expect(response).to render_template :show
    end

    it 'when not logged in: render production display page' do
      get :show, id: production
      expect(response).to render_template :show
    end
  end

  context 'attempt visit production index' do
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
