require 'rails_helper'

describe ProductionsController, type: :controller do
  let(:user) { create :user }
  let(:add_production) { attributes_for :add_production }
  let(:add_theatre) { attributes_for :add_theatre }
  let(:theatre) { attributes_for :theatre }
  let!(:production) { create :production }

  let(:production_params) {
    {
      title: add_production[:title],
      first_date: add_production[:first_date],
      last_date: add_production[:last_date],
      press_date_wording: '',
      dates_tbc_note: '',
      dates_note: ''
    }
  }

  let(:non_existing_theatre) {
    { name: add_theatre[:name] }
  }

  let(:existing_theatre) {
    { name: theatre[:name] }
  }

  before(:each) do
    session[:user_id] = user.id
  end

  context 'creating production with associated theatre' do
    it 'theatre does not exist: new theatre is created and used for association' do
      production_params[:theatre_attributes] = non_existing_theatre
      expect { post :create, production: production_params }.to change { Theatre.count }.by 1
      production = Production.last
      theatre = Theatre.last
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end

    it 'theatre exists: existing theatre is used for association' do
      production_params[:theatre_attributes] = existing_theatre
      expect { post :create, production: production_params }.to change { Theatre.count }.by 0
      production = Production.last
      theatre = Theatre.first
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end
  end

  context 'updating production with associated theatre' do
    it 'theatre does not exist: new theatre is created and used for association' do
      production_params[:theatre_attributes] = non_existing_theatre
      expect { patch :update, id: production.id, url: production.url, production: production_params }
        .to change { Theatre.count }.by 1
      theatre = Theatre.last
      expect(production.reload.theatre).to eq theatre
      expect(theatre.productions).to include production
    end

    it 'theatre exists: existing theatre is used for association' do
      production_params[:theatre_attributes] = existing_theatre
      expect { patch :update, id: production.id, url: production.url, production: production_params }
        .to change { Theatre.count }.by 0
      theatre = Theatre.first
      expect(production.reload.theatre).to eq theatre
      expect(theatre.productions).to include production
    end
  end
end
