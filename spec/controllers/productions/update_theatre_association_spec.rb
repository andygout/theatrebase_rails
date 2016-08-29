require 'rails_helper'

describe ProductionsController, type: :controller do
  let(:user) { create :user }
  let(:production_attrs) { attributes_for :production }
  let(:theatre_attrs) { attributes_for :theatre }
  let!(:production) { create :production }

  let(:non_existing_theatre_attrs) {
    {
      name: theatre_attrs[:name]
    }
  }

  let(:existing_theatre_attrs) {
    {
      name: production.theatre.name
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
    }
  }

  before(:each) do
    session[:user_id] = user.id
  end

  context 'updating production with associated theatre' do
    it 'theatre does not exist: new theatre is created and used for association' do
      production_params[:theatre_attributes] = non_existing_theatre_attrs
      expect { patch :update, id: production.id, url: production.url, production: production_params }
        .to change { Theatre.count }.by 1
      theatre = Theatre.last
      production.reload
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end

    it 'theatre exists: existing theatre is used for association' do
      production_params[:theatre_attributes] = existing_theatre_attrs
      expect { patch :update, id: production.id, url: production.url, production: production_params }
        .to change { Theatre.count }.by 0
      theatre = Theatre.first
      production.reload
      expect(production.theatre).to eq theatre
      expect(theatre.productions).to include production
    end
  end

  context 'setting creator and updater associations of theatre when production is updated' do
    it 'theatre does not exist: theatre associates current user as creator and updater' do
      production_params[:theatre_attributes] = non_existing_theatre_attrs
      patch :update, id: production.id, url: production.url, production: production_params
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
      production_params[:theatre_attributes] = existing_theatre_attrs
      patch :update, id: production.id, url: production.url, production: production_params
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
