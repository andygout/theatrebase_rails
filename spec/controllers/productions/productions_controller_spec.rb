require 'rails_helper'

describe ProductionsController, type: :controller do
  let(:user) { create :user }
  let(:admin_user) { create :admin_user }
  let(:super_admin_user) { create :super_admin_user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let(:add_production) { attributes_for :add_production }
  let(:add_theatre) { attributes_for :add_theatre }
  let!(:production) { create :production }

  let(:production_params) {
    {
      title: add_production[:title],
      first_date: add_production[:first_date],
      last_date: add_production[:last_date],
      press_date_wording: '',
      dates_tbc_note: '',
      dates_note: '',
      theatre_attributes: { name: add_theatre[:name] }
    }
  }

  let(:production_whitespace_params) {
    {
      title: ' ' + add_production[:title] + ' ',
      first_date: add_production[:first_date],
      last_date: add_production[:last_date],
      dates_info: 3,
      press_date_wording: ' ' + add_production[:press_date_wording] + ' ',
      dates_tbc_note: ' ' + add_production[:dates_tbc_note] + ' ',
      dates_note: ' ' + add_production[:dates_note] + ' ',
      theatre_attributes: { name: ' ' + add_theatre[:name] + ' ' }
    }
  }

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
    it 'as super-admin: succeed and redirect to production display page' do
      session[:user_id] = super_admin_user.id
      expect { post :create, production: production_params }.to change { Production.count }.by 1
      production = Production.last
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as admin: succeed and redirect to production display page' do
      session[:user_id] = admin_user.id
      expect { post :create, production: production_params }.to change { Production.count }.by 1
      production = Production.last
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as non-admin: succeed and redirect to production display page' do
      session[:user_id] = user.id
      expect { post :create, production: production_params }.to change { Production.count }.by 1
      production = Production.last
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      expect { post :create, production: production_params }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      expect { post :create, production: production_params }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      expect { post :create, production: production_params }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { post :create, production: production_params }.to change { Production.count }.by 0
      expect(response).to redirect_to log_in_path
    end

    it 'permitted create will remove leading and trailing whitespace from string fields' do
      session[:user_id] = user.id
      post :create, production: production_whitespace_params
      production = Production.last
      expect(production.title).to eq add_production[:title]
      expect(production.press_date_wording).to eq add_production[:press_date_wording]
      expect(production.dates_tbc_note).to eq add_production[:dates_tbc_note]
      expect(production.dates_note).to eq add_production[:dates_note]
    end
  end

  context 'attempt edit production' do
    it 'as super-admin: render production edit form' do
      session[:user_id] = super_admin_user.id
      get :edit, id: production.id, url: production.url
      expect(response).to render_template :edit
    end

    it 'as admin: render production edit form' do
      session[:user_id] = admin_user.id
      get :edit, id: production.id, url: production.url
      expect(response).to render_template :edit
    end

    it 'as non-admin: render production edit form' do
      session[:user_id] = user.id
      get :edit, id: production.id, url: production.url
      expect(response).to render_template :edit
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      get :edit, id: production.id, url: production.url
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      get :edit, id: production.id, url: production.url
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      get :edit, id: production.id, url: production.url
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      get :edit, id: production.id, url: production.url
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt update production' do
    it 'as super-admin: succeed and redirect to production display page' do
      session[:user_id] = super_admin_user.id
      patch :update, id: production.id, url: production.url, production: production_params
      expect(add_production[:title]).to eq production.reload.title
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as admin: succeed and redirect to production display page' do
      session[:user_id] = admin_user.id
      patch :update, id: production.id, url: production.url, production: production_params
      expect(add_production[:title]).to eq production.reload.title
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as non-admin: succeed and redirect to production display page' do
      session[:user_id] = user.id
      patch :update, id: production.id, url: production.url, production: production_params
      expect(add_production[:title]).to eq production.reload.title
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      patch :update, id: production.id, url: production.url, production: production_params
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      patch :update, id: production.id, url: production.url, production: production_params
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      patch :update, id: production.id, url: production.url, production: production_params
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      patch :update, id: production.id, url: production.url, production: production_params
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to log_in_path
    end

    it 'permitted update will remove leading and trailing whitespace from string fields' do
      session[:user_id] = user.id
      patch :update, id: production.id, url: production.url, production: production_whitespace_params
      production.reload
      expect(production.title).to eq add_production[:title]
      expect(production.press_date_wording).to eq add_production[:press_date_wording]
      expect(production.dates_tbc_note).to eq add_production[:dates_tbc_note]
      expect(production.dates_note).to eq add_production[:dates_note]
    end
  end

  context 'attempt delete production' do
    it 'as super-admin: succeed and redirect to home page' do
      session[:user_id] = super_admin_user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by -1
      expect(response).to redirect_to productions_path
    end

    it 'as admin: succeed and redirect to home page' do
      session[:user_id] = admin_user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by -1
      expect(response).to redirect_to productions_path
    end

    it 'as non-admin: succeed and redirect to home page' do
      session[:user_id] = user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by -1
      expect(response).to redirect_to productions_path
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { delete :destroy, id: production.id, url: production.url }.to change { Production.count }.by 0
      expect(response).to redirect_to log_in_path
    end
  end

  context 'attempt show production display page' do
    it 'as super-admin: render production display page' do
      session[:user_id] = super_admin_user.id
      get :show, id: production.id, url: production.url
      expect(response).to render_template :show
    end

    it 'as admin: render production display page' do
      session[:user_id] = admin_user.id
      get :show, id: production.id, url: production.url
      expect(response).to render_template :show
    end

    it 'as non-admin: render production display page' do
      session[:user_id] = user.id
      get :show, id: production.id, url: production.url
      expect(response).to render_template :show
    end

    it 'as suspended super-admin: render production display page' do
      session[:user_id] = suspended_super_admin_user.id
      get :show, id: production.id, url: production.url
      expect(response).to render_template :show
    end

    it 'as suspended admin: render production display page' do
      session[:user_id] = suspended_admin_user.id
      get :show, id: production.id, url: production.url
      expect(response).to render_template :show
    end

    it 'as suspended non-admin: render production display page' do
      session[:user_id] = suspended_user.id
      get :show, id: production.id, url: production.url
      expect(response).to render_template :show
    end

    it 'when not logged in: render production display page' do
      get :show, id: production.id, url: production.url
      expect(response).to render_template :show
    end
  end

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