require 'rails_helper'

describe ProductionsController, type: :controller do
  let(:user) { create :user }
  let(:production_attrs) { attributes_for :production }
  let(:theatre_attrs) { attributes_for :theatre }
  let!(:production) { create :production }

  let(:non_existing_theatre_attrs) {
    { name: theatre_attrs[:name] }
  }

  let(:existing_theatre_attrs) {
    { name: production.theatre.name }
  }

  before(:each) do
    session[:user_id] = user.id
  end

  context 'creating production with associated theatre' do
    it 'theatre does not exist: new theatre is created and used for association' do
      production_attrs[:theatre_attributes] = non_existing_theatre_attrs
      expect { post :create, production: production_attrs }.to change { Theatre.count }.by 1
      production = Production.last
      theatre = Theatre.last
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end

    it 'theatre exists: existing theatre is used for association' do
      production_attrs[:theatre_attributes] = existing_theatre_attrs
      expect { post :create, production: production_attrs }.to change { Theatre.count }.by 0
      production = Production.last
      theatre = Theatre.first
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end
  end

  context 'setting creator and updater associations of theatre when production is created' do
    it 'theatre does not exist: theatre associates current user as creator and updater' do
      production_attrs[:theatre_attributes] = non_existing_theatre_attrs
      post :create, production: production_attrs
      theatre = Theatre.last
      expect(theatre.creator).to eq user
      expect(theatre.updater).to eq user
      expect(user.created_theatres).to include theatre
      expect(user.updated_theatres).to include theatre
    end

    it 'theatre exists: theatre retains its existing associated creator and updater' do
      theatre = Theatre.first
      creator = theatre.creator
      updater = theatre.updater
      production_attrs[:theatre_attributes] = existing_theatre_attrs
      post :create, production: production_attrs
      theatre.reload
      expect(theatre.creator).to eq creator
      expect(theatre.creator).not_to eq user
      expect(theatre.updater).to eq updater
      expect(theatre.updater).not_to eq user
      expect(creator.created_theatres).to include theatre
      expect(user.created_theatres).not_to include theatre
      expect(updater.updated_theatres).to include theatre
      expect(user.updated_theatres).not_to include theatre
    end
  end

  context 'updating production with associated theatre' do
    it 'theatre does not exist: new theatre is created and used for association' do
      production_attrs[:theatre_attributes] = non_existing_theatre_attrs
      expect { patch :update, id: production.id, url: production.url, production: production_attrs }
        .to change { Theatre.count }.by 1
      theatre = Theatre.last
      production.reload
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end

    it 'theatre exists: existing theatre is used for association' do
      production_attrs[:theatre_attributes] = existing_theatre_attrs
      expect { patch :update, id: production.id, url: production.url, production: production_attrs }
        .to change { Theatre.count }.by 0
      theatre = Theatre.first
      production.reload
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end
  end

  context 'setting creator and updater associations of theatre when production is updated' do
    it 'theatre does not exist: theatre associates current user as creator and updater' do
      production_attrs[:theatre_attributes] = non_existing_theatre_attrs
      patch :update, id: production.id, url: production.url, production: production_attrs
      theatre = Theatre.last
      expect(theatre.creator).to eq user
      expect(theatre.updater).to eq user
      expect(user.created_theatres).to include theatre
      expect(user.updated_theatres).to include theatre
    end

    it 'theatre exists: theatre retains its existing associated creator and updater' do
      theatre = Theatre.first
      creator = theatre.creator
      updater = theatre.updater
      production_attrs[:theatre_attributes] = existing_theatre_attrs
      patch :update, id: production.id, url: production.url, production: production_attrs
      theatre.reload
      expect(theatre.creator).to eq creator
      expect(theatre.creator).not_to eq user
      expect(theatre.updater).to eq updater
      expect(theatre.updater).not_to eq user
      expect(creator.created_theatres).to include theatre
      expect(user.created_theatres).not_to include theatre
      expect(updater.updated_theatres).to include theatre
      expect(user.updated_theatres).not_to include theatre
    end
  end
end
