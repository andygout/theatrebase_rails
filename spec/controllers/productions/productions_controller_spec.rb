require 'rails_helper'

describe ProductionsController, type: :controller do
  let(:user) { create :user }
  let(:admin_user) { create :admin_user }
  let(:super_admin_user) { create :super_admin_user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let(:production_attrs) { attributes_for :production }
  let(:theatre_attrs) { attributes_for :theatre }
  let!(:production) { create :production }
  let(:creator) { production.creator }

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
    before(:each) do
      production_attrs[:theatre_attributes] = { name: theatre_attrs[:name] }
    end

    it 'as super-admin: succeed and redirect to production display page' do
      session[:user_id] = super_admin_user.id
      expect { post :create, production: production_attrs }.to change { Production.count }.by 1
      production = Production.last
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as admin: succeed and redirect to production display page' do
      session[:user_id] = admin_user.id
      expect { post :create, production: production_attrs }.to change { Production.count }.by 1
      production = Production.last
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as non-admin: succeed and redirect to production display page' do
      session[:user_id] = user.id
      expect { post :create, production: production_attrs }.to change { Production.count }.by 1
      production = Production.last
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      expect { post :create, production: production_attrs }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      expect { post :create, production: production_attrs }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      expect { post :create, production: production_attrs }.to change { Production.count }.by 0
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      expect { post :create, production: production_attrs }.to change { Production.count }.by 0
      expect(response).to redirect_to log_in_path
    end

    it 'permitted create will remove leading and trailing whitespace from string fields' do
      session[:user_id] = user.id
      whitespace_production_attrs = production_attrs.transform_values { |v| " #{v} " }
      whitespace_theatre_attrs = theatre_attrs.transform_values { |v| " #{v} " }
      whitespace_production_attrs[:theatre_attributes] = { name: whitespace_theatre_attrs[:name] }
      post :create, production: whitespace_production_attrs
      production = Production.last
      expect(production.title).to eq production_attrs[:title]
      expect(production.press_date_wording).to eq production_attrs[:press_date_wording]
      expect(production.dates_tbc_note).to eq production_attrs[:dates_tbc_note]
      expect(production.dates_note).to eq production_attrs[:dates_note]
      expect(production.theatre.name).to eq production_attrs[:theatre_attributes][:name]
    end

    it 'permitted create will set creator and updater associations' do
      session[:user_id] = user.id
      post :create, production: production_attrs
      production = Production.last
      expect(production.creator).to eq user
      expect(production.updater).to eq user
      expect(user.created_productions).to include production
      expect(user.updated_productions).to include production
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
    before(:each) do
      production_attrs[:theatre_attributes] = { name: theatre_attrs[:name] }
    end

    it 'as super-admin: succeed and redirect to production display page' do
      session[:user_id] = super_admin_user.id
      patch :update, id: production.id, url: production.url, production: production_attrs
      expect(production_attrs[:title]).to eq production.reload.title
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as admin: succeed and redirect to production display page' do
      session[:user_id] = admin_user.id
      patch :update, id: production.id, url: production.url, production: production_attrs
      expect(production_attrs[:title]).to eq production.reload.title
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as non-admin: succeed and redirect to production display page' do
      session[:user_id] = user.id
      patch :update, id: production.id, url: production.url, production: production_attrs
      expect(production_attrs[:title]).to eq production.reload.title
      expect(response).to redirect_to production_path(production.id, production.url)
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      patch :update, id: production.id, url: production.url, production: production_attrs
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      patch :update, id: production.id, url: production.url, production: production_attrs
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      patch :update, id: production.id, url: production.url, production: production_attrs
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      patch :update, id: production.id, url: production.url, production: production_attrs
      expect(production.title).to eq production.reload.title
      expect(response).to redirect_to log_in_path
    end

    it 'permitted update will remove leading and trailing whitespace from string fields' do
      session[:user_id] = user.id
      whitespace_production_attrs = production_attrs.transform_values { |v| " #{v} " }
      whitespace_theatre_attrs = theatre_attrs.transform_values { |v| " #{v} " }
      whitespace_production_attrs[:theatre_attributes] = { name: whitespace_theatre_attrs[:name] }
      patch :update, id: production.id, url: production.url, production: whitespace_production_attrs
      production.reload
      expect(production.title).to eq production_attrs[:title]
      expect(production.press_date_wording).to eq production_attrs[:press_date_wording]
      expect(production.dates_tbc_note).to eq production_attrs[:dates_tbc_note]
      expect(production.dates_note).to eq production_attrs[:dates_note]
      expect(production.theatre.name).to eq production_attrs[:theatre_attributes][:name]
    end

    it 'permitted update with valid params will retain existing creator association and update updater association' do
      session[:user_id] = user.id
      patch :update, id: production.id, url: production.url, production: production_attrs
      production.reload
      expect(production.creator).to eq creator
      expect(production.updater).to eq user
      expect(creator.created_productions).to include production
      expect(creator.updated_productions).not_to include production
      expect(user.created_productions).not_to include production
      expect(user.updated_productions).to include production
    end

    it 'permitted update with invalid params will retain existing creator and updater associations' do
      session[:user_id] = user.id
      production_attrs[:title] = ''
      patch :update, id: production.id, url: production.url, production: production_attrs
      production.reload
      expect(production.creator).to eq creator
      expect(production.updater).to eq creator
      expect(creator.created_productions).to include production
      expect(creator.updated_productions).to include production
      expect(user.created_productions).not_to include production
      expect(user.updated_productions).not_to include production
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
