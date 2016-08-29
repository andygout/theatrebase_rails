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

  let(:theatre_params) {
    {
      name: theatre_attrs[:name]
    }
  }

  let(:production_params) {
    {
      title:              production_attrs[:title],
      first_date:         production_attrs[:first_date],
      last_date:          production_attrs[:last_date],
      dates_info:         production_attrs[:dates_info],
      press_date_wording: production_attrs[:press_date_wording],
      dates_tbc_note:     production_attrs[:dates_tbc_note],
      dates_note:         production_attrs[:dates_note],
      theatre_attributes: theatre_params
    }
  }

  let(:whitespace_production_params) { add_whitespace_to_values(production_params) }

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
  end

  context 'permitted production creation' do
    it 'will remove leading and trailing whitespace from string fields' do
      session[:user_id] = user.id
      post :create, production: whitespace_production_params
      production = Production.last
      expect(production.title).to eq production_params[:title]
      expect(production.press_date_wording).to eq production_params[:press_date_wording]
      expect(production.dates_tbc_note).to eq production_params[:dates_tbc_note]
      expect(production.dates_note).to eq production_params[:dates_note]
      expect(production.theatre.name).to eq theatre_params[:name]
    end

    it 'will set creator and updater associations' do
      session[:user_id] = user.id
      post :create, production: production_params
      production = Production.last
      expect(production.creator).to eq user
      expect(production.updater).to eq user
      expect(user.created_productions).to include production
      expect(user.updated_productions).to include production
    end
  end
end
