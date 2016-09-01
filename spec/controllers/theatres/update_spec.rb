require 'rails_helper'

describe TheatresController, type: :controller do
  let(:user) { create :user }
  let(:admin_user) { create :admin_user }
  let(:super_admin_user) { create :super_admin_user }
  let(:suspended_super_admin_user) { create :suspended_super_admin_user }
  let(:suspended_admin_user) { create :suspended_admin_user }
  let(:suspended_user) { create :suspended_user }
  let(:theatre_attrs) { attributes_for :theatre }
  let!(:production) { create :production }
  let!(:theatre) { production.theatre }
  let(:theatre_creator) { theatre.creator }
  let(:second_theatre) { create :theatre }

  let(:theatre_params) {
    {
      name: theatre_attrs[:name]
    }
  }

  let(:whitespace_theatre_params) { add_whitespace_to_values(theatre_params) }

  context 'attempt update theatre' do
    it 'as super-admin: succeed and redirect to theatre display page' do
      session[:user_id] = super_admin_user.id
      patch :update, url: theatre.url, theatre: theatre_params
      expect(theatre_attrs[:name]).to eq theatre.reload.name
      expect(response).to redirect_to theatre_path(theatre.url)
    end

    it 'as admin: succeed and redirect to theatre display page' do
      session[:user_id] = admin_user.id
      patch :update, url: theatre.url, theatre: theatre_params
      expect(theatre_attrs[:name]).to eq theatre.reload.name
      expect(response).to redirect_to theatre_path(theatre.url)
    end

    it 'as non-admin: succeed and redirect to theatre display page' do
      session[:user_id] = user.id
      patch :update, url: theatre.url, theatre: theatre_params
      expect(theatre_attrs[:name]).to eq theatre.reload.name
      expect(response).to redirect_to theatre_path(theatre.url)
    end

    it 'as suspended super-admin: fail and redirect to home page' do
      session[:user_id] = suspended_super_admin_user.id
      patch :update, url: theatre.url, theatre: theatre_params
      expect(theatre.name).to eq theatre.reload.name
      expect(response).to redirect_to root_path
    end

    it 'as suspended admin: fail and redirect to home page' do
      session[:user_id] = suspended_admin_user.id
      patch :update, url: theatre.url, theatre: theatre_params
      expect(theatre.name).to eq theatre.reload.name
      expect(response).to redirect_to root_path
    end

    it 'as suspended non-admin: fail and redirect to home page' do
      session[:user_id] = suspended_user.id
      patch :update, url: theatre.url, theatre: theatre_params
      expect(theatre.name).to eq theatre.reload.name
      expect(response).to redirect_to root_path
    end

    it 'when not logged in: fail and redirect to log in page' do
      patch :update, url: theatre.url, theatre: theatre_params
      expect(theatre.name).to eq theatre.reload.name
      expect(response).to redirect_to log_in_path
    end
  end

  context 'permitted theatre update' do
    before(:each) do
      session[:user_id] = user.id
    end

    it 'will remove leading and trailing whitespace from string fields' do
      session[:user_id] = user.id
      patch :update, url: theatre.url, theatre: whitespace_theatre_params
      theatre.reload
      expect(theatre.name).to eq theatre_attrs[:name]
    end

    it 'with valid params will retain existing creator association and update updater association' do
      session[:user_id] = user.id
      patch :update, url: theatre.url, theatre: theatre_params
      theatre.reload
      expect(theatre.creator).to eq theatre_creator
      expect(theatre.updater).to eq user
      expect(theatre_creator.created_theatres).to include theatre
      expect(theatre_creator.updated_theatres).not_to include theatre
      expect(user.created_theatres).not_to include theatre
      expect(user.updated_theatres).to include theatre
    end

    it 'with invalid params will retain existing creator and updater associations' do
      session[:user_id] = user.id
      theatre_params[:name] = ''
      patch :update, url: theatre.url, theatre: theatre_params
      theatre.reload
      expect(theatre.creator).to eq theatre_creator
      expect(theatre.updater).to eq theatre_creator
      expect(theatre_creator.created_theatres).to include theatre
      expect(theatre_creator.updated_theatres).to include theatre
      expect(user.created_theatres).not_to include theatre
      expect(user.updated_theatres).not_to include theatre
    end

    it 'submitting a name that creates a URL already taken by another theatre will re-render the edit form' do
      initial_url = theatre.url
      theatre_params[:name] = second_theatre[:name]
      patch :update, url: theatre.url, theatre: theatre_params
      theatre.reload
      expect(response).to render_template :edit
      expect(theatre.url).to eq initial_url
    end

    it 'submitting a name that creates the existing URL theatre will redirect to theatre display page' do
      initial_url = theatre.url
      theatre_params[:name] = theatre[:name]
      patch :update, url: theatre.url, theatre: theatre_params
      theatre.reload
      expect(response).to redirect_to theatre_path(theatre.url)
      expect(theatre.url).to eq initial_url
    end

    it 'submitting a name that creates a URL not yet taken by any theatre will redirect to theatre display page' do
      patch :update, url: theatre.url, theatre: theatre_params
      theatre.reload
      expect(response).to redirect_to theatre_path(theatre.url)
      expect(theatre.url).to eq theatre_attrs[:url]
    end
  end
end
