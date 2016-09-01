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

  context 'attempt delete theatre (with no existing associations)' do
    before(:each) do
      Production.destroy(theatre.productions.first.id)
    end

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

  context 'attempt delete theatre (with existing associations)' do
    it 'associated production exists: fail and redirect to theatre display page' do
      session[:user_id] = user.id
      expect { delete :destroy, url: theatre.url }.to change { Theatre.count }.by 0
      expect(response).to redirect_to theatre_path(theatre.url)
    end
  end
end
